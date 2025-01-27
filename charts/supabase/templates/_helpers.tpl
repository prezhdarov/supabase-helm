{{/*
Expand the name of the chart.
*/}}
{{- define "supabase.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "supabase.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "supabase.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "supabase.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "supabase.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "supabase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "supabase.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "supabase.secret" -}}
  {{- printf "%s-secret" (include "supabase.fullname" .) | toString -}}
{{- end -}}

{{- define "supabase.jwt.secretRef" -}}
  {{- default (include "supabase.secret" .) .Values.jwt.existingSecret }}
{{- end -}}

{{- define "supabase.externalURL" -}}
  {{- default "http://exmaple.com" .Values.externalURL -}}
{{- end -}}

{{- define "supabase.defaultOrganization" -}}
  {{- default "Default Organization" .Values.defaultOrganization -}}
{{- end -}}

{{- define "supabase.defaultProject" -}}
  {{- default "Default Project" .Values.defaultProject -}}
{{- end -}}


{{- define "supabase.jwt.secret" -}}
  {{- .Values.jwt.secret | b64enc -}}
{{- end -}}
{{- define "supabase.jwt.anonKey" -}}
  {{- .Values.jwt.anonKey | b64enc -}}
{{- end -}}
{{- define "supabase.jwt.serviceKey" -}}
  {{- .Values.jwt.serviceKey | b64enc -}}
{{- end -}}


{{- define "supabase.db" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- printf "%s-db" (include "supabase.fullname" .) -}}
  {{- else -}}
    {{- .Values.db.external.host -}}
  {{- end -}}    
{{- end -}}

{{- define "supabase.db.port" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- printf "%s" "5432" | toString -}}
  {{- else -}}
    {{- default "5432" .Values.db.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.db.ssl" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- printf "%s" "disable" -}}
  {{- else -}}
    {{- .Values.db.external.sslmode -}}
  {{- end -}}
{{- end -}} 

{{- define "supabase.db.init-scripts" -}}
  {{- printf "%s-init-scripts" (include "supabase.db" .) -}}
{{- end -}}

{{- define "supabase.db.migrations" -}}
  {{- printf "%s-migrations" (include "supabase.db" .) -}}
{{- end -}}

{{- define "supabase.db.username" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- printf "%s" "postgres" -}}
  {{- else -}}
    {{- .Values.db.external.username -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.db.database" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- printf "%s" "postgres" -}}
  {{- else -}}
    {{- .Values.db.external.database -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.db.password" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- .Values.db.internal.password | b64enc -}}
  {{- else -}}
    {{- .Values.db.external.password | b64enc -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.db.secretRef" -}}
  {{- if eq .Values.db.type "internal" -}}
    {{- default (include "supabase.secret" .) .Values.db.internal.existingSecret }}
  {{- else -}}
    {{- default (include "supabase.secret" .) .Values.db.external.existingSecret }}
  {{- end -}}
{{- end -}}

{{- define "supabase.studio" -}}
  {{- printf "%s-studio" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.studio.username" -}}
  {{- default "supabase" .Values.studio.username -}}
{{- end -}}

{{- define "supabase.studio.password" -}}
  {{- .Values.studio.password | b64enc -}}
{{- end -}}

{{- define "supabase.studio.secretRef" -}}
  {{- default (include "supabase.secret" .) .Values.studio.existingSecret }}
{{- end -}}

{{- define "supabase.kong" -}}
  {{- printf "%s-kong" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.kong.internalURL" -}}
  {{- printf "http://%s:8000" (include "supabase.kong" .) }}
{{- end -}}

{{- define "supabase.kong.config" -}}
  {{- printf "%s-config" (include "supabase.kong" .) }}
{{- end -}}

{{- define "supabase.kong.tlsSecret" -}}
  {{- printf "%s-tls" (include "supabase.kong" .) }}
{{- end -}}

{{- define "supabase.auth" -}}
  {{- printf "%s-auth" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.auth.email.secretRef" -}}
  {{- default (include "supabase.secret" .) .Values.auth.email.existingSecret }}
{{- end -}}

{{- define "supabase.auth.email.password" -}}
  {{- .Values.auth.email.password | b64enc -}}
{{- end -}}

{{- define "supabase.auth.email.paths.invite" -}}
  {{- if .Values.auth.email.urlPaths -}}
    {{- .Values.auth.email.urlPaths.invite | default "/auth/v1/verify" -}}
  {{- else -}}
    {{- print "/auth/v1/verify" -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.auth.email.paths.recovery" -}}
  {{- if .Values.auth.email.urlPaths -}}
    {{- .Values.auth.email.urlPaths.recovery | default "/auth/v1/verify" -}}
  {{- else -}}
    {{- print "/auth/v1/verify" -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.auth.email.paths.confirmation" -}}
  {{- if .Values.auth.email.urlPaths -}}
    {{- .Values.auth.email.urlPaths.conmfirmation | default "/auth/v1/verify" -}}
  {{- else -}}
    {{- print "/auth/v1/verify" -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.auth.email.paths.change" -}}
  {{- if .Values.auth.email.urlPaths -}}
    {{- .Values.auth.email.urlPaths.change | default "/auth/v1/verify" -}}
  {{- else -}}
    {{- print "/auth/v1/verify" -}}
  {{- end -}}
{{- end -}}

{{- define "supabase.rest" -}}
  {{- printf "%s-rest" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.realtime" -}}
  {{- printf "%s-realtime" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.realtime.secretKeyBase" -}}
  {{- .Values.realtime.secretKeyBase | b64enc -}}
{{- end -}}

{{- define "supabase.realtime.secretRef" -}}
  {{- default (include "supabase.secret" .) .Values.realtime.existingSecret }}
{{- end -}}

{{- define "supabase.realtime.db.encryptionKey" -}}
  {{- .Values.realtime.db.encryptionKey | b64enc -}}
{{- end -}}

{{- define "supabase.realtime.db.secretRef" -}}
  {{- default (include "supabase.secret" .) .Values.realtime.db.existingSecret }}
{{- end -}}

{{- define "supabase.realtime.internalHost" -}}
  {{- if .Values.realtime.selfHosted -}}
    {{- printf "realtime-dev" -}}
  {{- else -}}
    {{- printf "%s" (include "supabase.realtime" .) }}
  {{- end -}}
{{- end -}}

{{- define "supabase.storage" -}}
  {{- printf "%s-storage" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.functions" -}}
  {{- printf "%s-functions" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.functions.main" -}}
  {{- printf "%s-main" (include "supabase.functions" .) -}}
{{- end -}}

{{- define "supabase.functions.hello" -}}
  {{- printf "%s-hello" (include "supabase.functions" .) -}}
{{- end -}}

{{- define "supabase.analytics" -}}
  {{- printf "%s-analytics" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.meta" -}}
  {{- printf "%s-meta" (include "supabase.fullname" .) -}}
{{- end -}}

{{- define "supabase.meta.internalURL" -}}
  {{- printf "http://%s:8080" (include "supabase.meta" .) }}
{{- end -}}