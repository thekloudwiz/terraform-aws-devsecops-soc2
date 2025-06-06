# Setting Up Act for Local GitHub Actions Testing

## Installation

### Windows (using Chocolatey)
```powershell
choco install act-cli
```

### Windows (manual)
1. Download the latest release from https://github.com/nektos/act/releases
2. Extract the executable to a directory in your PATH

### Mac
```bash
brew install act
```

### Linux
```bash
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## Configuration

1. I've created a `.actrc` file in your `.github` directory with basic configuration.
2. Update the secret values in `.actrc` with your actual tokens and values.
3. I've also created a simple test workflow in `.github/workflows/act-test.yml`.

## Docker Requirements

Act requires Docker to be installed and running on your system. Make sure Docker Desktop is installed and running.

## Running Act

### Test with the simple workflow first:
```bash
cd c:\Users\IsaacTandoh\Downloads\isaac_tandoh\terraform-aws-devsecops-soc2
act -j test-job -W .github/workflows/act-test.yml
```

### Run the app-ci workflow:
```bash
# List all jobs in the workflow
act -l -W .github/workflows/app-ci.yml

# Run a specific job (e.g., security-checks)
act pull_request -j security-checks -W .github/workflows/app-ci.yml

# Run with event payload
act pull_request -e event.json -W .github/workflows/app-ci.yml
```

### Run the infra-ci workflow:
```bash
act pull_request -j validate -W .github/workflows/infra-ci.yml
```

## Creating Event Payload

Create a file named `event.json` with content like:

```json
{
  "pull_request": {
    "number": 123,
    "head": {
      "ref": "feature-branch"
    }
  },
  "repository": {
    "name": "terraform-aws-devsecops-soc2"
  },
  "ref_name": "dev",
  "base_ref": "dev"
}
```

## Limitations

1. Some actions might not work perfectly with Act
2. AWS credential handling might need additional configuration
3. Some third-party actions might require additional setup

## Troubleshooting

1. If you see Docker errors, make sure Docker is running
2. For permission issues, try running Act with administrator privileges
3. For missing secrets, update the `.actrc` file with proper values
4. For action compatibility issues, check the [Act GitHub issues](https://github.com/nektos/act/issues)

## Resources

- [Act GitHub Repository](https://github.com/nektos/act)
- [Act Documentation](https://github.com/nektos/act#readme)