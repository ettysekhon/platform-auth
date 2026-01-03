{{/*
Expand the name of the chart.
*/}}
{{- define "platform-auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "platform-auth.fullname" -}}
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
{{- define "platform-auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-auth.labels" -}}
helm.sh/chart: {{ include "platform-auth.chart" . }}
{{ include "platform-auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Keycloak labels
*/}}
{{- define "platform-auth.keycloak.labels" -}}
{{ include "platform-auth.labels" . }}
app.kubernetes.io/component: keycloak
{{- end }}

{{/*
Keycloak selector labels
*/}}
{{- define "platform-auth.keycloak.selectorLabels" -}}
{{ include "platform-auth.selectorLabels" . }}
app.kubernetes.io/component: keycloak
{{- end }}

{{/*
PostgreSQL labels
*/}}
{{- define "platform-auth.postgres.labels" -}}
{{ include "platform-auth.labels" . }}
app.kubernetes.io/component: postgres
{{- end }}

{{/*
PostgreSQL selector labels
*/}}
{{- define "platform-auth.postgres.selectorLabels" -}}
{{ include "platform-auth.selectorLabels" . }}
app.kubernetes.io/component: postgres
{{- end }}

{{/*
PostgreSQL hostname
*/}}
{{- define "platform-auth.postgres.hostname" -}}
{{- printf "%s-postgres" (include "platform-auth.fullname" .) }}
{{- end }}
