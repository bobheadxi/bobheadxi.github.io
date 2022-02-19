---
title: "Self-documenting and self-updating tooling"
layout: post
image: https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/google/313/pencil_270f-fe0f.png
hero_image: false
headerImage: true
maths: false
featured: false
tag:
- golang
- docs
- automation
- sourcegraph
category: blog
author: robert
description: building self-sustaining ecosystems
---

In a rapidly moving organization, documentation drift is inevitable as the underlying tools undergoes changes to suit business needs, especially for internal tools where leaning on tribal knowledge can often seem more efficient in the short term. However, this introduces documentation debt that makes for a confusing onboarding process and poor experience as an organization grows.

One approach for keeping documentation debt at bay is to choose tools that come with automated writing of documentation built-in. You can design your code in such a way that code documentation generators can also double as user guides (which I explored with [my rewrite of the UBC Launch Pad website](2020-4-25-introducing-new-launch-pad-site.md)'s generated [configuration documentation](https://ubclaunchpad.com/config)), or specifications that can generate both code and documentation (which I tried with [Inertia](2018-4-29-building-inertia.md)'s [API reference](https://inertia.ubclaunchpad.com/api/)). Some libraries, like Cobra, a Go library for build CLIs, can also generate reference documentation for commands (such as [Inertia](2018-4-29-building-inertia.md)'s [CLI reference](https://inertia.ubclaunchpad.com/cli/inertia.html)). This allows you to meet your users where they are - for example, the less technically oriented can check out a website while the more hands-on users can find what they need within the code or in the command line - while maintaining a single source of truth that keeps everything up to date.

Of course, in addition to generated documentation you do still need to write documentation to tie the pieces together - for example, the [UBC Launch Pad website still had a brief intro guide](https://github.com/ubclaunchpad/ubclaunchpad.com/blob/master/README.md) and we did put together a [usage guide for Inertia](https://inertia.ubclaunchpad.com/), but generated documentation helps you ensure the nitty gritty stays up to date, and focus on high-level guidance in your handcrafted writing.

At [Sourcegraph](../_experience/2021-7-5-sourcegraph.md), I've been exploring avenues for taking this even further. Once you move away from off-the-shelf generators and invest in leveraging your code to generate exactly what you need, you can build a pretty neat ecosystem of documentation, integrations, and tooling that is always up to date by design and enables some cool features. In this article, I'll talk about some of the things we've built with this approach in mind: our [observability ecosystem](#observability-ecosystem) and our [continuous integration pipelines](#continuous-integration-pipelines).

<br />

## Observability ecosystem

The Sourcegraph product has shipped with Prometheus metrics and Grafana dashborads for quite a while, used both by Sourcegraph for [Sourcegraph Cloud](https://sourcegraph.com) and by self-hosted customers to operate Sourcegraph instances. These have been created from our own Go-based specification since before I started working here. The spec would look something like this (truncated for brevity):

{% raw %}

```go
func GitServer() *Container {
	return &Container{
        Name:        "gitserver",
        Title:       "Git Server",
        Description: "Stores, manages, and operates Git repositories.",
        Groups: []Group{{
            Title: "General",
            Rows: []Row{{
                // Each dashboard panel and alert is associated with an "observable"
                Observable{
                    Name:        "disk_space_remaining",
                    Description: "disk space remaining by instance",
                    Query:       `(src_gitserver_disk_space_available / src_gitserver_disk_space_total)*100`,
                    // Configure Prometheus alerts
                    Warning: Alert{LessOrEqual: 25},
                    // Configure Grafana panel
                    PanelOptions: PanelOptions().LegendFormat("{{instance}}").Unit(Percentage),
                    // Some options, like this one, makes changes to both how the panel
                    // is rendered as well as when the alert fires
                    DataMayNotExist: true,
                    // Configure documentation
                    PossibleSolutions: `
                        - **Provision more disk space:** Sourcegraph will begin deleting...
                    `,
                },
            }},
        }},
    },
}
```

<figure>
    <figcaption>
        Explore
        <a href="https://sourcegraph.com/github.com/sourcegraph/sourcegraph@3.17/-/blob/monitoring/git_server.go">what our monitoring generator looked like in Sourcegraph 3.17</a>
        (circa mid-2020)
    </figcaption>
</figure>

{% endraw %}

From here, a program will import the definitions and generate the appropriate Prometheus [recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/), Grafana [dashboard specs](https://grafana.com/docs/grafana/latest/dashboards/json-model/), and a simple customer-facing "alert solutions" page. Any changes that engineers made to their monitoring definitions using the specification would automatically update everything that needed to be updated, no additional work needed.

For example, the Grafana dashboard spec generation automatically calculates appropriate widths and heights for each panel you add, ensuring they are evenly distributed and include lines that indicate Prometheus alert thresholds, a uniform look and feel, and more.

I loved this idea, so I ran with it and worked on a series of changes that expanded the capabilities of this system significantly. Today, our monitoring specification powers:

- Multiple reference pages: a [revamped alerts reference](https://docs.sourcegraph.com/admin/observability/alert_solutions) and a page that [focuses on background information about each dashboard panel](https://docs.sourcegraph.com/admin/observability/dashboards), that both customers and engineers at Sourcegraph can reference. It now also includes information about which teams own what dashboards and alerts to help customer support better triage support requests.

<figure>
    <img src="/assets/images/posts/self-documenting/alert-reference.png" />
    <figcaption>
        Generated documentation includes provided guidance as well as generated guidance for other features in the ecosystem, such as links to the dashboard reference, configuration snippets to disable the alert, and links to the team that owns the alert.
    </figcaption>
</figure>

- Grafana dashboards that now automatically includes links to the generated documentation, annotation layers for generated alerts, improved alert overview graphs, and more.

<figure>
    <video autoplay="" loop="" muted="" playsinline="" style="width: 100%; height: auto">
        <source src="/assets/images/posts/self-documenting/dashboard-annotations.webm" type="video/webm">
    </video>
    <figcaption>
        Version and alert annotations in Sourcegraph's generated dashboards. Dashboard like these are automatically provided by defining observables using our monitoring specification, alongside everything else mentioned previously.
    </figcaption>
</figure>

- Prometheus integration that now generates more granular [alert rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) that include additional metadata such as the ID of the associated generated dashboard panel, the team that owns the alert, and more.
- An entirely new Alertmanager integration ([related blog post](2020-06-21-docker-sidecar.md)) that allows you to [easily configure alert notifications via the Sourcegraph application](https://docs.sourcegraph.com/admin/observability/alerting#setting-up-alerting), which automatically sets up the appropriate routes and configures messages to include relevant information for triaging alerts: a helpful summary, links to documentation, and links to the relevant dashboard panel in the time window of the alert. This leverages the aforementioned generated Prometheus metrics!

<figure>
    <img src="/assets/images/posts/self-documenting/alert-notification.png" />
    <figcaption>
        Automatically configured alert notification messages feature a helpful summary and links to diagnose the issue further for a variety of supported notification services, such as Slack and OpsGenie.
    </figcaption>
</figure>

The API has changed as well to improve its flexibility and enable many of the features listed above. Nowadays, a monitoring specification might look like this (also truncated for brevity):

{% raw %}

```go
// Definitions are separated from the API so everything is imported from 'monitoring' now,
// which allows for a more tightly controlled API.
func GitServer() *monitoring.Container {
    return &monitoring.Container{
        Name:        "gitserver",
        Title:       "Git Server",
        Description: "Stores, manages, and operates Git repositories.",
        // Easily create template variables without diving into the underlying JSON spec
        Variables: []monitoring.ContainerVariable{{
            Label:        "Shard",
            Name:         "shard",
            OptionsQuery: "label_values(src_gitserver_exec_running, instance)",
            Multi:        true,
        }},
        Groups: []monitoring.Group{{
            Title: "General",
            Rows: []monitoring.Row{{
                {
                    Name:        "disk_space_remaining",
                    Description: "disk space remaining by instance",
                    Query:       `(src_gitserver_disk_space_available / src_gitserver_disk_space_total)*100`,
                    // Alerting API expanded with additional options to leverage more
                    // Prometheus features
                    Warning: monitoring.Alert().LessOrEqual(25).For(time.Minute),
                    Panel: monitoring.Panel().LegendFormat("{{instance}}").
                        Unit(monitoring.Percentage).
                        // Functional configuration API that allows you to provide a
                        // callback to configure the underlying Grafana panel further, or
                        // use one of the shared options to share common options
                        With(monitoring.PanelOptions.LegendOnRight()),
                    // Owners can now be defined on observables, which allows support
                    // to help triage customer queries and is used internally to route
                    // pager alerts
                    Owner: monitoring.ObservableOwnerCoreApplication,
                    // Documentation fields are still around, but an 'Interpretation' can
                    // now also be provided for more obscure background on observables,
                    // especially if they aren't tied to an alert
                    PossibleSolutions: `
                        - **Provision more disk space:** Sourcegraph will begin deleting...
                    `,
                },
            }},
        }},
    }
}           
```

{% endraw %}

<figure>
    <figcaption>
        Explore
        <a href="https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/monitoring/definitions/git_server.go">what our monitoring generator looks like today</a>!
    </figcaption>
</figure>

Since the specification is built on a typed language, the API itself is self-documenting in that authors of monitoring definitions can easily access what options are available and what each does through [generated API docs](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/docs/monitoring/monitoring) or code intelligence available in Sourcegraph or in your IDE.

![](../../assets/images/posts/self-documenting/monitoring-api-hover.png)

![](../../assets/images/posts/self-documenting/monitoring-api-docs.png)

We also now have a tool, [`sg`](https://docs.sourcegraph.com/dev/background-information/sg), that enables us to spin up just the monitoring stack, complete with hot-reloading of Grafana dashboards, Prometheus configuration, and with a single command: `sg start monitoring`. You can even easily [test your dashboards against production metrics](https://docs.sourcegraph.com/dev/how-to/monitoring_local_dev#grafana)! This is all enabled by having a single tool and set of specifications as the source of truth for all our monitoring integrations.

This all comes together to form a cohesive monitoring development and usage ecosystem that is tightly integrated, encodes best practices, self-documenting (both in the content it generates as well as the APIs available), and easy to extend.

Learn more about our observability ecosystem in our [developer documentation](https://docs.sourcegraph.com/dev/background-information/observability), and check out the [monitoring generator source code here](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/monitoring/monitoring/generator.go).

<br />

## Continuous integration pipelines

At Sourcegraph, our core continuous integration pipeline are - you guessed it - generated! Our [pipeline generator program]() analyzes a build's variables: changes, branch names, commit messages, environment variables, and more in order to create a pipeline to run on our [Buildkite](https://buildkite.com/) agent fleet.