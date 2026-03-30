# Xsolla School Helm Charts

Helm chart repository for Xsolla School services, published via GitHub Pages.

## Setup (one-time)

Enable GitHub Pages on the repository:

1. Go to **Settings → Pages**
2. Set **Source** to `Deploy from a branch`
3. Set **Branch** to `gh-pages` / `(root)`
4. Save

The `gh-pages` branch is created automatically on the first successful workflow run.

## Adding the repository

```bash
helm repo add xsolla-school https://ahmedzidan.github.io/helm-charts
helm repo update
```

## Available charts

| Chart | Version | Description |
|-------|---------|-------------|
| [checkout-api](charts/checkout-api/README.md) | 0.1.0 | Xsolla School Checkout API |

## Publishing a new version

1. Make your changes to the chart templates or values.
2. Bump `version` in `charts/<chart>/Chart.yaml`.
3. Push to `main`.

The [release workflow](.github/workflows/release.yaml) automatically packages the chart, creates a GitHub Release, and updates the Helm repo index on `gh-pages`.

## Repository structure

```
charts/
└── checkout-api/
    ├── Chart.yaml            # Chart metadata and version
    ├── values.yaml           # Default values (all environments)
    ├── values-dev.yaml       # Dev overrides
    ├── values-staging.yaml   # Staging overrides
    └── templates/
        ├── _helpers.tpl      # Shared template functions
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        └── secret.yaml
```