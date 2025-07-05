# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
