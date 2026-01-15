# Pipelines Dedicated Containers

This folders contains all the dedicated containers used inside the GitLab pipelines. Relying on official images of the
various tools and languages is sometimes limiting on the things that we can do inside a single job so we build these
images.

All images will start from the `base-pipeline` image that contains syft, cosign and basic utilities for easier scripting
during the job execution.
