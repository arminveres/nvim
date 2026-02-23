; bash in common nixpkgs phases/hooks
(
  (binding
    attrpath: (attrpath (identifier) @attr)
    expression: (indented_string_expression (string_fragment) @injection.content)
  )
  (#match? @attr "^(shellHook|buildPhase|checkPhase|installPhase|preBuild|postBuild|preInstall|postInstall|configurePhase)$")
  (#set! injection.language "bash")
)

; zsh
(
  (binding
    attrpath: (attrpath (identifier) @attr)
    expression: (indented_string_expression (string_fragment) @injection.content)
  )
  (#match? @attr "^(completionInit|envExtra|initContent)$")
  (#set! injection.language "zsh")
)

