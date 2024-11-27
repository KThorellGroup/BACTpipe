[![DOI](https://zenodo.org/badge/83326100.svg)](https://zenodo.org/badge/latestdoi/83326100)

# BACTpipe 
BACTpipe is a whole genome sequencing workflow. It does quality assessment of
paired input reads, tries to assess if the sample contains mixed or pure
isolates, performs *de novo* assembly, and annotates the assembled genome.
BACTpipe uses Nextflow as a workflow manager. 

![BACTpipe flowchart](./docs/source/img/BACTpipe_3-1_flow.png)

## Documentation
Complete documentation is available at https://bactpipe.readthedocs.io. 

## Quick-start
You need to have [Nextflow](https://www.nextflow.io), and [conda](https://conda.io/docs/) installed.
When running with the default local profile all other software will be installed into local environments by conda througout the process. 

## Run BACTpipe
Nextflow makes it easy to run BACTpipe:

    $ nextflow run KThorellGroup/BACTpipe --reads 'path/to/reads/*_R{1,2}.fastq.gz'

This will run BACTpipe locally. For more details on how to run BACTpipe, see
the official documentation at https://bactpipe.readthedocs.io.

## License
BACTpipe is published under the MIT license 2018-2021

## Authors

- Abhinav Sharma (@abhi18av)
- Emilio Rudbeck (@emilio-r)
- Joseph Kirangwa (@b16joski),
- Sandra Alvarez-Carretero (@sabifo4),
- Fredrik Boulund (@boulund),
- Kaisa Thorell (@thorellk)
