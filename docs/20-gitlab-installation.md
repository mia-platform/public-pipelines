# How to Use the GitLab CI/CD in your Organization

To use effectively the GitLab CI/CD pipelines templates in your organizations you have to save them in your
GitLab instance if you use self-service or inside the group of your organization inside GitLab SaaS.

To do so we provide a [script](../bin/gitlab/install) you can run that will copy all the required files
in a dedicated project.

## Requirements

- [git] installed and configured with username and email
- [jq]
- a user on the target GitLab instance that can create groups
- a personal access token of that user with `api` and `write_repository` permissions

## Configuration File

To run correctly you will need to setup the configuration file with the appropriate values. You can find it in this
repository under [`bin` > `gitlab > config.json`](../bin/gitlab/config.json) and below you can find the default content:

```json
{
	"instance_url": "https://gitlab.com",
	"group_id": "",
	"pipeline_images_base_name": "ghrc.io/mia-platform",
	"default_visibility": "internal"
}
```

For an explanation of the various keys and possible values reference the following table:

| key | value |
| --- | --- |
| **instance_url** | The url of the GitLab instance, default to the GitLab SaaS installation |
| **group_id** | The id of the parent group where to create the pipeline template project, if left empty a `mia-platform` group will be created on the root of the instance, for GitLab SaaS this values cannot be empty |
| **pipeline_images_base_name** | If you cannot access directly the public repositories where the images for the jobs are hosted you can change this to the mirror where they will be available |
| **default_visibility** | The visibility set for the project and optional group that will be created, by default they will be set as internal, but you can set `public` or `private` if you need to |

## Install the Templates

1. clone the repository on your local machine

	```sh
	git clone https://github.com/mia-platform/public-pipelines.git
	```

1. edit the default values of the confiugration file with your favorite editor

	```sh
	${EDITOR} ./public-pipelines/bin/gitlab/config.json
	```

1. set the GitLab username and token as env variables

	```sh
	export GITLAB_USERNAME="<username>"
	export GITLAB_TOKEN="<user-token>"
	```

1. run the script

	```sh
	./public-pipelines/bin/gitlab/install -u "${GITLAB_USERNAME}" \
		-t "${GITLAB_TOKEN}" -c \
		"./public-pipelines/bin/gitlab/config.json"
	```

1. after the run is complete you can delete the cloned repository if you want

	```sh
	rm -fr ./public-pipelines
	```

## Setting Pipeline Templates

If you are a Premium subscriber you can use the newly created project as an instance or group template repository.
All pipelines used for the public marketplace can also be used as templates for your projects that not use the console.

[git]: https://git-scm.com (Git is a free and open source distributed version control system )
[jq]: https://jqlang.github.io/jq/ (jq is a lightweight and flexible command-line JSON processor)
