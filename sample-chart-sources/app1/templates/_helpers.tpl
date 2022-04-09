{{/*
Expand the name of the chart.
*/}}
{{- define "app1.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app1.fullname" -}}
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
{{- define "app1.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app1.labels" -}}
helm.sh/chart: {{ include "app1.chart" . }}
{{ include "app1.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app1.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app1.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app1.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app1.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "helpers.list-configmap-variables"}}
{{- $fullName := include "app1.fullname" . -}}
{{- range $key, $val := .Values.env.configmap }}
- name: {{ $key | upper }}
  valueFrom:
    configMapKeyRef:
      name: {{ $fullName }}-configmap
      key: {{ $key }}
{{- end}}
{{- end }}

{{- define "helpers.list-secret-variables"}}
{{- $fullName := include "app1.fullname" . -}}
{{- range $key, $val := .Values.env.secret }}
- name: {{ $key | upper }}
  valueFrom:
    secretKeyRef:
      name: {{ $fullName }}-secret
      key: {{ $key }}
{{- end}}
{{- end }}

{{- define "helpers.list-startupProbe-httpGet-headers"}}
{{- range $key, $val := .Values.livenessProbe.httpGet.httpHeaders }}
- name: {{ $key }}
  value: {{ $val }}
{{- end}}
{{- end }}

{{- define "helpers.list-readinessProbe-httpGet-headers"}}
{{- range $key, $val := .Values.livenessProbe.httpGet.httpHeaders }}
- name: {{ $key }}
  value: {{ $val }}
{{- end}}
{{- end }}

{{- define "helpers.list-livenessProbe-httpGet-headers"}}
{{- range $key, $val := .Values.livenessProbe.httpGet.httpHeaders }}
- name: {{ $key }}
  value: {{ $val }}
{{- end}}
{{- end }}

