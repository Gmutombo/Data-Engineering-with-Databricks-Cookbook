FROM spark-delta-os-base:latest

# -- Image Metadata
ARG build_date
LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Data Engineering with Apache Spark and Delta Lake Cookbook - Spark base image"
LABEL org.label-schema.schema-version="1.0"

# -- Versions
ARG spark_version=3.4.1
ARG hadoop_version=3
ARG delta_package=io.delta:delta-core_2.12:2.4.0
ARG spark_xml_package=com.databricks:spark-xml_2.12:0.17.0
ARG spark_kafka_package=org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1

# -- Install Spark
RUN curl -fsSL https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz \
    -o spark.tgz \
 && tar -xzf spark.tgz \
 && mv spark-${spark_version}-bin-hadoop${hadoop_version} /opt/spark \
 && rm spark.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH
ENV PYSPARK_PYTHON=python3

# -- Spark config
RUN mkdir -p $SPARK_HOME/conf && \
    echo "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.jars.packages=${delta_package},${spark_xml_package},${spark_kafka_package}" >> $SPARK_HOME/conf/spark-defaults.conf

# -- Runtime user
ARG NBuser=nbuser
ARG GROUP=nbuser

RUN groupadd -r ${GROUP} && useradd -m -r -g ${GROUP} ${NBuser} \
 && chown -R ${NBuser}:${GROUP} /opt/spark \
 && chown -R ${NBuser}:${GROUP} ${SHARED_WORKSPACE}

USER ${NBuser}
WORKDIR ${SPARK_HOME}
