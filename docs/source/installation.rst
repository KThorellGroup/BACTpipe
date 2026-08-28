Installation
============
BACTpipe pipeline is written in Nextflow and runs on Linux and Mac OSX systems.

Dependencies
************
In order to run `BACTpipe`_, you need to have the following programs installed:

- `Java v8+`_ for Nextflow 
- `Nextflow`_ for workflow management, more specifically `v26.04.0`_
- `Conda`_ for installation of workflow tools
- (Optional) A `Kraken2 database`_ if you want to classify taxonomy and gram
  stain to potentially improve genome annotations in the Prokka step.

.. _BACTpipe: https://github.com/KThorellGroup/BACTpipe
.. _Java v8+: https://www.java.com/sv/download/help/download_options.xml
.. _Nextflow: https://www.nextflow.io/
.. _Conda: https://docs.conda.io/en/latest/
.. _Kraken2 database: http://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads


Install BACTpipe
****************
After installing all the beforementioned dependencies, `BACTpipe`_ will
automatically install the software needed for the process using conda when
running the pipeline. 


Quick guide on how to install most tools
****************************************

1. Java v8+: https://anaconda.org/cyclus/java-jdk
2. Nextflow: https://www.nextflow.io/docs/latest/getstarted.html#installation
3. Conda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/
4. Kraken2 database: http://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads

.. tip::
   The repository contains a convenience script to easily download a Kraken2 DB:
   ``resources/download_kraken2_db.sh``.
