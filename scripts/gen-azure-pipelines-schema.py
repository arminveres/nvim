#!/usr/bin/env python3
"""Build an azure-pipelines YAML schema usable by yaml-language-server, merged
with marketplace extension tasks (e.g. jfrog) read from their task.json files.

The upstream MS schema relies on `aliases` (MS VSCode extension only) and
models every scalar as a string. yamlls ignores aliases, which yields bogus
errors such as `String does not match the pattern of "^PowerShell@2$"`.
This script turns aliases into plain properties and loosens scalar types.
Matching stays case-sensitive (MS `ignoreCase` is deliberately not emulated).

Usage: gen-azure-pipelines-schema.py <tasks-dir> [<tasks-dir> ...] <output.json>
  <tasks-dir> = directory containing */task.json
  (e.g. jfrog-azure-devops-extension/tasks)
"""

import json
import re
import sys
import urllib.request
from pathlib import Path

BASE_SCHEMA_URL = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json"
# ponytail: pipelines accept any scalar where MS says string/bool/int, so type checks
# on scalars are dropped entirely; tighten per-type if that hides real mistakes.
SCALAR = ["string", "boolean", "number", "integer"]
SCALAR_TYPES = set(SCALAR)


def esc(s: str) -> str:
    return re.sub(r"([.*+?^${}()|\[\]\\/])", r"\\\1", s)


def yamllsify(node):
    """Rewrite MS-only schema keywords into ones yamlls understands (in place)."""
    if isinstance(node, list):
        for x in node:
            yamllsify(x)
        return
    if not isinstance(node, dict):
        return
    for v in list(node.values()):
        yamllsify(v)

    t = node.get("type")
    if isinstance(t, str) and t in SCALAR_TYPES:
        node["type"] = SCALAR

    # aliases → extra exact-name properties (added after recursion, so the
    # shared subschemas aren't rewritten twice)
    props = node.get("properties")
    if isinstance(props, dict):
        for sub in list(props.values()):
            if isinstance(sub, dict):
                for alias in sub.get("aliases") or []:
                    props.setdefault(alias, sub)


def extension_task_defs(tasks_dirs):
    for d in tasks_dirs:
        for task_json in Path(d).glob("*/task.json"):
            try:
                t = json.loads(task_json.read_text())
            except (json.JSONDecodeError, OSError):
                continue
            name, major = t.get("name"), t.get("version", {}).get("Major")
            if not name or major is None:
                continue
            ref = f"{name}@{major}"
            desc = (
                f"{t.get('friendlyName', name)}\n\n{t.get('description', '')}".strip()
            )
            inputs = {
                i["name"]: {
                    "description": i.get("label", i["name"]),
                    **({"aliases": i["aliases"]} if i.get("aliases") else {}),
                    **(
                        {"enum": list(i["options"])}
                        if i.get("type") == "pickList"
                        and i.get("options")
                        and not (i.get("properties") or {}).get("EditableOptions")
                        == "True"
                        else {}
                    ),
                }
                for i in t.get("inputs", [])
                if i.get("name")
            }
            completion = {"description": desc, "enum": [ref]}
            definition = {
                "properties": {
                    "task": {"description": desc, "pattern": f"^{esc(ref)}$"},
                    "inputs": {
                        "description": f"{name} inputs",
                        "properties": inputs,
                        "additionalProperties": False,
                    },
                },
                "firstProperty": ["task"],
                "required": ["task"],
            }
            yield completion, definition


def main() -> None:
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    *tasks_dirs, out_path = sys.argv[1:]
    with urllib.request.urlopen(BASE_SCHEMA_URL) as r:
        schema = json.load(r)

    task = schema["definitions"]["task"]
    n = 0
    for completion, definition in extension_task_defs(tasks_dirs):
        task["properties"]["task"]["anyOf"].append(
            completion
        )  # `task:` value completion
        task["anyOf"].append(definition)  # per-task validation + inputs completion
        n += 1

    yamllsify(schema)
    Path(out_path).write_text(json.dumps(schema))
    print(f"wrote {out_path} (+{n} extension tasks)")


if __name__ == "__main__":
    main()
