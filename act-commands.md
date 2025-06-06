# Act Commands for Testing Workflows

## Setup

1. Make sure Docker is running
2. Update values in `.github/act-secrets.env` with your actual credentials
3. Run the commands below from the repository root

## Test Commands

### Test the simple workflow first:

```bash
act -W .github/workflows/act-test.yml
```

### App CI Workflow

Test security-checks job:

```bash
act pull_request -j security-checks -W .github/workflows/app-ci.yml -e event.json
```

Test build-and-test-image job:

```bash
act pull_request -j build-and-test-image -W .github/workflows/app-ci.yml -e event.json
```

### App CD Workflow

Test deploy job:

```bash
act push -j deploy -W .github/workflows/app-cd.yml -e event.json
```

### Infra CI Workflow

Test validate job:

```bash
act pull_request -j validate -W .github/workflows/infra-ci.yml -e event.json
```

### Infra CD Workflow

Test terraform-plan job:

```bash
act pull_request -j terraform-plan -W .github/workflows/infra-cd.yml -e event.json --input-file .github/act-pr-merged.json
```

Test terraform-apply job:

```bash
act pull_request -j terraform-apply -W .github/workflows/infra-cd.yml -e event.json --input-file .github/act-pr-merged.json
```

## Debugging

Add `-v` flag for verbose output:

```bash
act -v pull_request -j security-checks -W .github/workflows/app-ci.yml -e event.json
```

List all jobs without running them:

```bash
act -l -W .github/workflows/app-ci.yml
```

## AWS Credentials

For AWS authentication, you can use:

1. AWS CLI credentials from your local machine:

```bash
act -W .github/workflows/app-ci.yml --secret-file ~/.aws/credentials
```

2. Or set AWS environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_SESSION_TOKEN=your_session_token
act -W .github/workflows/app-ci.yml
```