# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Probes accept an optional `timeout` key, rendered as `timeoutSeconds`.
  Omitted, the rendered output is unchanged (Kubernetes defaults to 1s).

- `ingress.pathPrefix` now accepts a list of strings in addition to a single
  string. When a list is provided, the IngressRoute matches any of the listed
  prefixes via OR'd `PathPrefix(...)` matchers under the same host match. The
  existing single-string shape renders byte-identical output.

## [2.6.1] - 2025-10-03

### Fixed

- Disabled setting replicas when `autoscaling.enabled` true

## [2.6.0] - 2025-09-24

### Added

- Added KEDA NATS JetStream scaler support with event-driven autoscaling

## [2.5.0] - 2025-07-04

### Added

- Added proper opentelemetry service name annotation to the `deployment`
  so it gets picked up by loki.

## [2.4.0] - 2025-04-23

### Added

- Added sensitivity to `deployment.replicas` in values to set the base
  number of replicas (prior to any autoscaling being applied). Defaults
  of `2` when `env` is `prod` and `1` otherwise are still in effect
  unless this value is overridden.
