FROM registry.access.redhat.com/ubi8/ubi@sha256:edb918518a6300897740a81a407fc7ca391d84b8c45830632f29f5282ee071a3 AS builder

# renovate: datasource=github-tags depName=hashicorp/terraform
ARG TERRAFORM_VERSION=1.4.5

# renovate: datasource=github-tags depName=gruntwork-io/terragrunt
ARG TERRAGRUNT_VERSION=0.37.1

RUN yum install -y unzip && \
    yum clean all && \
    rm -rf /var/cache/dnf/*

# terraform
RUN curl -fsSL -o terraform_linux_amd64.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_linux_amd64.zip terraform && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform_linux_amd64.zip

# terragrunt
#RUN curl -sfLO https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64 && \
#    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
#    chmod +x /usr/local/bin/terragrunt
RUN curl -sfLO https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# mirror terraform providers
COPY providers.tf providers.tf
RUN mkdir /usr/local/terraform-providers && \
    terraform providers mirror -platform=linux_amd64 /usr/local/terraform-providers

FROM registry.access.redhat.com/ubi8/ubi@sha256:edb918518a6300897740a81a407fc7ca391d84b8c45830632f29f5282ee071a3

ENV TF_CLI_ARGS_init="-plugin-dir=/usr/local/terraform-providers"

COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terragrunt /usr/local/bin/
COPY --from=builder /usr/local/terraform-providers /usr/local/terraform-providers
