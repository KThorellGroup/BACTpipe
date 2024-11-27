Running BACTpipe
================
After installing all the required dependencies and downloading the required
mash sketches of refseq genomes, it is very easy to run BACTpipe. There are
several ways to run BACTpipe, but we'll start with the easiest::

    $ nextflow run ctmrbio/BACTpipe --reads 'path/to/reads/*_R{1,2}.fastq.gz'

This will instruct Nextflow to go to the ``ctmrbio`` Github organization to
download and run the ``BACTpipe`` workflow. The argument ``--reads`` is used to
tell the workflow which input files you want to run BACTpipe on. Note that the
path to the reads must be enclosed in single quotes (``'``) to prevent the
shell from automatically expanding asterisks (``*``) and curly braces (``{}``).
In the above example, the part of the filename matched by the asterisk will be
used as the sample name in BACTpipe, and ``{1,2}`` refers to the pair of FASTQ
files for paired-end data. Input data should be in FASTQ format, and can be
either plain FASTQ, or compressed with gzip or bzip2 (with ``.gz`` or ``.bz2``
file suffixes). 

.. note::

    When you run BACTpipe for the first time using a command like the one
    shown above, Nextflow downloads the current version of the Github repo
    to your computer. If BACTpipe is updated after your first run, the 
    subsequent runs will still use the old version that you have downloaded.
    To get the newest version, tell Nextflow to update your local copy:
    ``nextflow pull ctmrbio/BACTpipe``.

When BACTpipe is run like this, it by default assumes you want to run
everything locally, on the current machine.  Note that BACTpipe is capable of
running on a wide range of computers, ranging from laptops to powerful
multicore machines to high-performance computing (HPC) clusters. 


Changing settings on the command line
-------------------------------------
When running BACTpipe, you may want to modify parameters to customize it for
your purpose. It is possible to modify several settings for how BACTpipe
operates using configuration parameters. All changes can be added as
command-line arguments when running BACTpipe, e.g.::

    $ nextflow run ctmrbio/BACTpipe --prokka_evalue 1e-24 --reads 'path/to/reads/*_{1,2}.fastq.gz'

The ``--prokka_evalue`` flag will modify the kmer lengths that `prokka`_ will
use when blasting for annotation. The following parameters can be easily configured
from the command line::

    Parameter name            Default setting        Description
    reads                     [empty]                Input fastq files, required!
    output_dir                BACTpipe_results       Name of outuput directory
    keep_trimmed_fastq        [FALSE]                Output trimmed fastq files from fastp into output_dir
    keep_shovill_output       [FALSE]                Output shovill output directory into output_dir
    kraken2_db                [empty]                Path to Kraken2 database to use for taxonomic classification
    kraken2_confidence        0.5                    Kraken2 confidence parameter, refer to `kraken2` documentation for details
    kraken2_min_proportion    1.00                   Minimum proportion of reads on sample level to classify sample as containing species 
    shovill_depth             100                    See the `shovill` documentation for details
    shovill_minlen            500
    prokka_evalue             1e-09                  See the `prokka` documentation for details
    prokka_kingdom            Bacteria                      
    prokka_reference          [not used]
    prokka_signal_peptides    false    
    
.. _shovill: https://github.com/tseemann/shovill
.. _prokka: https://github.com/tseemann/prokka
.. _kraken2: http://ccb.jhu.edu/software/kraken2

To modify any parameter, just add ``--<parameter_name> <new_setting>`` on the
command line when running BACTpipe, e.g. ``--shovill_depth 75`` to set
`shovill`_'s depth parameter to 75 instead of 100.  Refer to ``params.config`` in
the ``conf`` directory of the `BACTpipe repository`_ for a complete up-to-date
listing of all available parameters. 

.. _BACTpipe repository: https://www.github.com/ctmrbio/BACTpipe

Change many settings at once
............................
If you want to change many different settings at the same time when running
BACTpipe, it can quickly result in very long command lines. A way to make it
easier to change several parameters at once is to create a custom configuration
file in YAML or JSON format that you give to BACTpipe using ``-params-file``.

The parameter settings you define in your custom configuration file will
override the default settings. Custom configuration files can be written in
either YAML or JSON format. The simplest format for the custom parameters file
is probably YAML, and is the recommended choice. Here is an example YAML
configuration file that modifies some shovill parameters and leaves all other
settings to their default values::

    shovill_depth: "100"
    shovill_minlen: "400"

If you save the above into a plain text file called ``custom_bactpipe_config.yaml`` 
you can provide it when running BACTpipe using the ``-params-file`` command 
line argument::

    $ nextflow run ctmrbio/BACTpipe -params-file path/to/your/custom/params.yaml --reads 'path/to/reads/*_{1,2}.fastq.gz'

There is also another way to modify parameters that uses Nextflow's own
configuration format. This can be useful if you want to modify *a lot* of
settings at once, since it is possible to download a copy of the default
configuration settings file directly from Github, `params.config`_, and make
any changes you want directly in your custom version of ``params.config``. The
file contains some comments explaining how the different variables work, to
help out when modifying the settings. To run BACTpipe with a custom
configuration in the Nextflow format, you use ``-c`` on the command line::

    $ nextflow run ctmrbio/BACTpipe -c path/to/custom_params.config --reads 'path/to/reads/*_{1,2}.fastq.gz'

.. _params.config: https://github.com/ctmrbio/BACTpipe/blob/master/conf/params.config

Note:
............................

There are two different type of commandline arguments when running workflows
using Nextflow: 1) arguments using double dashes (i.e. ``--reads``) and 2)
arguments using a single dash (i.e. ``-params-file``). Arguments using double
dashes are sent to BACTpipe for evaluation, and are typically configuration
variables that are defined inside BACTpipe. Arguments using a single dash are
not visible to BACTpipe but are instead used by Nextflow itself, and typically
alters how Nextflow executes BACTpipe. 


Profiles
--------
A convenient way to modify the way BACTpipe is run in your environment is to
load a profile. BACTpipe comes with a few pre-installed profiles:

* ``standard`` -- For local use on e.g. a laptop or Linux server. This is the
  default profile used if no profile is explicitly specified.
* ``dardel``-- For use on the PDC `Dardel`_ HPC system. **NOTE**, this profile has to be used together with the ``-with-apptainer`` flag since it is dependent on containerized software.
* ``docker`` -- For use with docker containers.

.. _Dardel: https://www.pdc.kth.se/hpc-services/computing-systems

And the now deprecated:

* ``ctmr_nas`` -- For local execution on CTMR's old analysis server.
* ``ctmr_gandalf`` -- For use on CTMR's Gandalf Slurm HPC system.
* ``rackham`` -- For use on the UPPMAX's Rackham HPC system.


.. sidebar:: Cluster profiles

    Note that when running profiles that uses a cluster scheduler, for example
    like Slurm that is used on the NAISS PDC system in the ``dardel`` profile, you
    also need to provide what Slurm account/project BACTpipe should use when
    submitting jobs. This can be done with ``--project account_name`` on the
    command line, or by adding it to a custom configuration file (see previous
    section).
 
To run BACTpipe with a specific profile, use the ``-profile <profilename>``
argument (note the single dash before ``profile``) when running, e.g.::

    $ nextflow run ctmrbio/BACTpipe -profile dardel --project SNIC001 --reads '/proj/projectname/reads/*_{1,2}.fastq.gz'

This will run BACTpipe using the ``dardel`` profile with the project set to
``SNIC001``, which automatically configures settings so BACTpipe can download
the required software and databases to the PDC HPC cluster environment.
Running BACTpipe without a ``-profile`` argument will default to running the
``standard`` profile directly on the node you are logged in to (avoid doing
that on shared HPC systems).


Custom profile
--------------
It is possible to create a custom profile to use instead of the preconfigured
ones. This is useful if you want to run BACTpipe on another cluster system than
PDC's Dardel, or if the data you are analyzing requires you to change the
pre-defined expected CPU, memory, and time requirements for processes on the
cluster. The best way to start is probably to download one of the pre-existing
profiles from `conf directory`_ of the `BACTpipe repository`_. 

.. _conf directory: https://github.com/ctmrbio/BACTpipe/tree/master/conf

If you are working on a Slurm-managed system, starting with either the
``dardel.config`` or the ``ctmr_gandalf`` profile would be a good choice, as
both of those are Slurm-managed HPC systems. Download the configuration file
from the `conf directory`_ of the `BACTpipe repository`_ and modify settings to
your preference. Then, to run BACTpipe using your custom configuration file,
you need to tell Nextflow to read parameters from your file instead of the
default parameters::

    $ nextflow run ctmrbio/BACTpipe -c path/to/your/custom/profile.config --reads 'path/to/reads/*_{1,2}.fastq.gz'

The custom profile is not limited to configuring CPU, memory and time limits
for the different processes. It is also possible to set parameter values inside
the custom profile, i.e. to change paths to reference databases or adjust
runtime parameters for the different processes. It is also possible to just use
a configuration file that changes settings without modifying how the workflow
is run, see :ref:`Change many settings at once`.


