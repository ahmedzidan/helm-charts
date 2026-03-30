{{/*
_helpers.tpl — reusable template snippets
These are "named templates" defined with `define` and called with `include`.
They keep the main templates DRY (Don't Repeat Yourself).
*/}}

{{/*
checkout-api.image
Builds the full GCP Artifact Registry image path.
GCP AR requires 4 segments: HOST/PROJECT/REPOSITORY/IMAGE:TAG

  registry  = us-west2-docker.pkg.dev/xsolla-school-experiments
  arRepo    = ahmed-zidan      ← student's AR repository (set via --set image.arRepo=)
  repository= checkout-api     ← image name inside the repository
  tag       = <commitSHA>      ← set by CI via --set image.tag=${CI_COMMIT_SHA}

Result: us-west2-docker.pkg.dev/xsolla-school-experiments/ahmed-zidan/checkout-api:abc123f
*/}}
{{- define "checkout-api.image" -}}
{{- printf "%s/%s/%s:%s" .Values.image.registry .Values.image.arRepo .Values.image.repository .Values.image.tag }}
{{- end }}

{{/*
checkout-api.labels
Common labels applied to all resources — used for grouping/querying in kubectl.
.Release.Namespace is the namespace passed via --namespace in the helm command.
*/}}
{{- define "checkout-api.labels" -}}
app.kubernetes.io/name: checkout-api
app.kubernetes.io/instance: {{ .Release.Namespace }}
app.kubernetes.io/managed-by: Helm
{{- end }}
