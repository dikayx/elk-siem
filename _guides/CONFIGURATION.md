# Configuration

This document will give you an overview of the current configuration. You don't need to change this if you just want to use the default settings.

-   `docker-compose.yml` is for overall docker configuration setup. To make it simple, this project uses `7.1.1` version instead of `8`, not to consider about the enrollment token and miscellaneous security settings. Also, **port** configuration will be standardized according to this yml file. Other applications or setting files shouldn't have any conflict with this file.

    ```yml
    # We will use ELK stack families with version of 71.1 (even including winlogbeat)
        elasticsearch:
            image: docker.elastic.co/elasticsearch/elasticsearch:7.1.1
                ports:
                - 9200:9200
                - 9300:9300
            # ...
        logstash:
            image: docker.elastic.co/logstash/logstash:7.1.1
                ports:
                - 5044:5044
                - 5000:5000/tcp   # <--- logstash will communicate with winlogbeat installed on Windows endpoint via this port (:5000 in this case.)
                - 5000:5000/udp
                - 9600:9600
            # ...
        kibana:
            image: docker.elastic.co/kibana/kibana:7.1.1
                ports:
                - 5601:5601
            # ...
    ```

-   `elasticsearch/config/elasticsearch.yml` is for Elasticsearch configuration. To make this service is accessible by everyone, I set `network.host` property as `0.0.0.0`.

    ```yml
    cluster.name: "docker-cluster"
    network.host: 0.0.0.0
    discovery.type: single-node
    ```

-   `kibana/config/kibana.yml` is for Kibana configuration. Because Kibana receives and interacts with Elasticsearch, Port number setting should be identical with `docker-compose.yml`.

    ```yml
    server.name: kibana
    server.host: 0.0.0.0
    elasticsearch.hosts: ["http://elasticsearch:9200"]
    xpack.monitoring.ui.container.elasticsearchenabled: true
    ```

-   `logstash/config/logstash.yml` is for Logstash configuration connected to elasticsearch(forwarding parsed and transformed data.). Port number setting should be identical with `docker-composes.yml`.

    ```yml
    http.host: "0.0.0.0"
    xpack.monitoring.elasticsearch.hosts: ["http:/elasticsearch:9200"]
    ```

-   `logstash/pipeline/logstash.conf` is for the Logstash pipelining configuration connected to any pre-configured Windows endpoint(from winlogbeat). `port` setting in `input` should correspond to both `docker-compose.yml` and winlogbeat YML setting file in Windows endpoint. `hosts` in `output` section describes Elasticsearch connection information. This information should be identical to `docker-compose.yml`. Other configurations may be adjusted for your needs(For parsing, indexing, transforming data during the pipelining procedure.).

    ```
    input {
        beats{
            port => 5000
        }
    }

    output {
        elasticsearch {
            hosts => "elasticsearch:9200"
            user => "username"
            password => "password"
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }
    ```
