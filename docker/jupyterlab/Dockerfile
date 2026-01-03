FROM spark-base:3.4.1

# -- Layer: Image Metadata

ARG build_date

LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Data Engineering wih Apache Spark and Delta Lake Cookbook - JupyterLab Image"
LABEL org.label-schema.description="JupyterLab image"


# -- Layer: Notebooks and data

# ADD docker/jupyterlab/kafka-producer.py /

# -- Layer: JupyterLab + Python kernel for PySpark


ARG jupyterlab_version=4.0.2
ARG sparksql_magic_version=0.0.3
ARG kafka_python_version=2.0.2


# ------------------------------------------------------------
# Python + Jupyter
# ------------------------------------------------------------

RUN pip3 install --no-cache-dir --break-system-packages  \
      jupyterlab==${jupyterlab_version} \
      sparksql-magic==${sparksql_magic_version} \
      kafka-python==${kafka_python_version} \
      delta-spark \
      pyspark

ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS="lab --ip=0.0.0.0 --no-browser --allow-root"
ENV JUPYTER_ENABLE_LAB=yes

EXPOSE 8888

WORKDIR /workspace

CMD ["jupyter", "lab"]
