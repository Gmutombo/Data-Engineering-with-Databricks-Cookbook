FROM spark-delta-os-base:latest

# -- Image Metadata
ARG build_date
LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Data Engineering with Apache Spark and Delta Lake Cookbook - Spark base image"
LABEL org.label-schema.schema-version="1.0"

# -- Versions
ARG spark_version
ARG hadoop_version
ARG scala_version
ARG delta_package_version
ARG spark_xml_package_version


ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH


RUN curl -fSL https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz \
 | tar -xz -C /opt \
 && mv /opt/spark-${spark_version}-bin-hadoop${hadoop_version} ${SPARK_HOME}

# ------------------------------------------------------------
# Spark packages (Delta + XML)
# ------------------------------------------------------------

RUN mkdir -p ${SPARK_HOME}/jars \
 && curl -fLo ${SPARK_HOME}/jars/delta-core.jar \
      https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar \
 && curl -fLo ${SPARK_HOME}/jars/spark-xml.jar \
      https://repo1.maven.org/maven2/com/databricks/spark-xml_2.12/0.16.0/spark-xml_2.12-0.16.0.jar

WORKDIR ${SPARK_HOME}
