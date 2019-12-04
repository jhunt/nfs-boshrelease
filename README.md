NFS on BOSH
===========

This BOSH release provides both halves of a working NFS volume
share.  With it, you can build a BOSH-deployed NAS device,
exporting disk space attached to the NFS server VM to clients.
You can also add remote filesystem mount support to existing
deployments, using the `nfs-client` job.

This BOSH release supports both Trusty and Xenial stemcells, and
can be trivially modified to support other Linux-based operating
systems as needed.

Configuring a Server
--------------------

To deploy a VM that will act as an NFS file server, you need to
colocate the `nfs-server` job, and provide a list of _exports_.

Here's an excerpt from a working manifest:

    instance_groups:
      - name: nas
        instances: 1
        persistent_disk: 81_920

        jobs:
          - name: nfs-server
            release: nfs
            properties:
              exports:

                # export /var/vcap/store/pub to all clients.
                #
                - path: pub


                # export /etc, read-only, to hosts in the
                # 10.5.0.0/24 and 10.6.0.0./24 subnets.
                #
                - path: /etc
                  options: [ro]
                  clients:
                    - 10.5.0.0/24
                    - 10.6.0.0/24

Configuring a Client
--------------------

To support remote mounts of NFS volumes, colocate the
`nfs-client` job alongside your other jobs and releases.


    instance_groups:
      - name: something-else
        jobs:
          - name: nfs-client
            release: nfs
            properties:
              mounts:

                # mount the web application code files over NFS,
                # from an intranet NAS / filer.  This mount gets
                # done during pre-start, so that it is available
                # to other jobs on the VM (like a web server).
                #
                - server: nas.example.com
                  remote: /web/app
                  local:  /var/vcap/data/app
                  when:   immediate


                # mount the web data files over NFS, in the BOSH
                # post-deploy hook (the default).  This mount will
                # not be available until after the jobs have
                # deployed successfully.
                #
                - server: nas.example.com
                  remote: /web/files
                  local:  /var/vcap/data/webfiles


Running an NFS-v4 Server
------------------------

If you want to run only NFSv4 you can set the `nfsd_arguments` and
`mountd_arguments` manifest properties, like so:

    instance_groups:
      - name: nas
        jobs:
          - name: nfs-server
            release: nfs
            properties:
              nfsd_arguments:   -N 2 -N 3 -V 4
              mountd_arguments: -N 2 -N 3 -V 4

The `-N` argument instructs the `rpc.mountd` and `rpc.nfsd`
processes to skip the named version (here v2 and v3).  The `-V`
argument turns _on_ version 4.


How Do I Contribute?
--------------------

  1. Fork this repo
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Added some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request in Github
  6. Profit!

