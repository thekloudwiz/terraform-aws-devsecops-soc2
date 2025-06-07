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

1. Update the secret values in `.github/act-secrets.env` with your actual tokens and values.
2. Use the provided helper scripts to run Act:
   - Windows: `run-act.ps1`
   - Linux/Mac: `run-act.sh` (make it executable with `chmod +x run-act.sh`)

## Docker Requirements

Act requires Docker to be installed and running on your system. Make sure Docker Desktop is installed and running.

## Running Act

### Test with the simple workflow first:
```bash
# Windows
.\run-act.ps1 -j test-job -W .github\workflows\act-test.yml

# Linux/Mac
./run-act.sh -j test-job -W .github/workflows/act-test.yml
```

### Run the app-ci workflow:
```bash
# Windows
.\run-act.ps1 pull_request -j security-checks -W .github\workflows\app-ci.yml -e event.json

# Linux/Mac
./run-act.sh pull_request -j security-checks -W .github/workflows/app-ci.yml -e event.json
```

### Run the infra-ci workflow:
```bash
# Windows
.\run-act.ps1 pull_request -j validate -W .github\workflows\infra-ci.yml -e event.json

# Linux/Mac
./run-act.sh pull_request -j validate -W .github/workflows/infra-ci.yml -e event.json
```

## How It Works

The workflows have been modified to detect when they're running in Act:

1. Each workflow checks for the `ACT` environment variable:
   ```yaml
   - name: Check if running in Act
     id: check-act
     run: |
       if [ -n "$ACT" ]; then
         echo "Running in Act environment"
         echo "is_act=true" >> $GITHUB_OUTPUT
       else
         echo "Running in GitHub Actions"
         echo "is_act=false" >> $GITHUB_OUTPUT
       fi
   ```

2. Steps that require GitHub-specific tokens are skipped when running in Act:
   ```yaml
   - name: Upload artifact
     if: steps.check-act.outputs.is_act != 'true'
     uses: actions/upload-artifact@v4
     with:
       name: test-artifact
       path: test-file.txt
   ```

3. The helper scripts set the `ACT=true` environment variable when running Act.

## Generating Secrets

To generate the secrets file with actual values from your infrastructure:

1. Apply your Terraform configuration:
   ```
   cd infra
   terraform init
   terraform workspace select dev
   terraform apply
   ```

2. Run the appropriate script for your OS:
   - Windows: `.\get-secrets.ps1 dev`
   - Linux/Mac: `./get-secrets.sh dev`

3. Update the manual entries in `.github/act-secrets.env`:
   - GitHub token
   - SonarCloud token
   - Snyk token
   - Slack webhook URL

## Troubleshooting

1. **Artifact Upload Errors**: These are expected when running in Act and will be skipped automatically.

2. **Docker Errors**: Make sure Docker is running and you have sufficient permissions.

3. **AWS Authentication**: If AWS commands fail, try one of these approaches:
   - Use your local AWS credentials: `act --secret-file ~/.aws/credentials`
   - Set AWS environment variables:
     ```
     export AWS_ACCESS_KEY_ID=your_access_key
     export AWS_SECRET_ACCESS_KEY=your_secret_key
     ./run-act.sh ...
     ```

4. **Missing Dependencies**: Some actions may require additional tools or dependencies. Install them locally if needed.

## Resources

- [Act GitHub Repository](https://github.com/nektos/act)
- [Act Documentation](https://github.com/nektos/act#readme)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)