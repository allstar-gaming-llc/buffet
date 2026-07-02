# Helm Chart
For now hosts a single `service` chart for all Kubernetes services deployed via
Helm. Located in a sub-directory (`service/`) so when new charts are added a
bunch of deployments don't have to be updated. See https://helm.sh/ for more
information about Helm.

## Repository
All charts in this repository are deployed to a helm repository that uses GitHub
Pages to house it's index.yaml. You can browse available charts and versions at
https://allstar-gaming-llc.github.io/buffet/index.yaml. When using a chart from
the repository the repository URL will be https://allstar-gaming-llc.github.io/helm.

## Usage
Check a chart's `Chart.yaml` for it's current version number and `values.yaml`
fora list of configurable options. If there is anything unusual at all about a
chart it should contain a `README.md` to explain, otherwise use as any other Helm
chart.


