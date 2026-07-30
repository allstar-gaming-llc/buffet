{{/* Creates a probe (liveness, readiness, startup, etc.) for a pod */}}
{{- define "probe" }}
{{- if .failureThreshold }}
failureThreshold: {{ .failureThreshold }}
{{- end }}
{{- if .initialDelay }}
initialDelaySeconds: {{ .initialDelay }}
{{- end }}
{{- if .period }}
periodSeconds: {{ .period }}
{{- end }}
{{- if .timeout }}
timeoutSeconds: {{ .timeout }}
{{- end }}
{{- if eq .type "httpGet" }}
httpGet:
  path: {{ .path }}
  port: {{ .port }}
  {{- if .headers }}
  httpHeaders:
  {{- range $header, $value := .headers }}
  - name: {{ $header }}
    value: {{ $value }}
  {{- end }}
  {{- end }}
{{- else if eq .type "exec" }}
exec:
  command:
  {{- range $value := .command }}
  - {{ $value }}
  {{- end }}
{{- end }}
{{- end }}

