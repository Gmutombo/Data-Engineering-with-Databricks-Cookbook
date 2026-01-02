ARG spark_version=3.4.1
FROM spark-base:${spark_version}

# -- Image Metadata
ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.description="Spark master image"
LABEL org.label-schema.schema-version="1.0"

# -- Ensure logs directory exists
RUN mkdir -p ${SPARK_HOME}/logs

# -- Runtime
EXPOSE 8080 7077

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
