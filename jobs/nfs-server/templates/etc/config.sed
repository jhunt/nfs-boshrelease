s/^RPCNFSDARGS=.*/RPCNFSDARGS="<%= p('nfsd_arguments', '') %> <%= p('nfsd_servers') %>"/;
s/^RPCMOUNTDARGS=.*/RPCMOUNTDARGS="<%= p('mountd_arguments', '') %>"/;
s/^STATDARGS=.*/STATDARGS="<%= p('statd_arguments', '') %>"/;
