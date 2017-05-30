
# OS Image Changes

OS images are stored in S3 bucket [bosh-os-images](http://s3.amazonaws.com/bosh-os-images/).


## Ubuntu 14.04

Ubuntu 14.04 images have filename `bosh-ubuntu-trusty-os-image.tgz`

* `k26h9ILhXuXFPICAsgQ1rpVLBkjVRtjJ`
  - USN-3304-1: Sudo vulnerability
  - built from 3421.x (e47eedee6177c6f5f6ba631aafa1acf9e4c56d2e)

* `ucvD5sewvM447sC5w9X7IRXHOa8QtAkI`
  - Periodic bump
  - built from 3421.x (7ee87952c73cbf511f483d11141769d23964d066)

* `r_WNtzobxc0nnQ8eGDlzholta243M8hq`
  - Periodic bump
  - built from master (68b92ffd4007625b994c12c21847c39b400b55f4)

* `v9zIu3GyTfQQaev5hhm6P8duLyg_PDqt`
  - cron should respect RANDOM_DELAY
  - built from master (70c5e98f42123eb763e1481458f65e5a7be1e161)

* `MU9r.9kKO4KZL3l9dzRxld.qN7K5m2y_`
  - Periodic bump
  - built from master (67b8ac6788ac388ad51707577c4a76b873c81d29)

* `AQpOEmagMszCmcKz4a1xI3v2No.bD.Fd`
  - Periodic bump
  - built from master (8961d5967d5b3f0da2f7827d23f14564948178da)

* `fq8XmHeuMOiaCZoEmcQUrevXt72rHqdi`
  - USN-3256-1: Linux kernel vulnerability
  - built from master (3d29282973a6a59427d66f3888b00061320b06e5)

* `ff_YrJAF76hBo2EVV4psTVHJLnIcrJiJ`
  - USN-3209-1: SCSI operation restriction
  - built from master (418178a706310bb8b6f363f8891bbe14990f0d49)

# Images are built from bosh-linux-stemcell-builder repo going ahead

* `ITQtbWQJP3w2b2SsGZ8dzHXaEupaiC.X`
  - USN-3209-1: SCSI operation restriction
  - built from master (523251dee4c4fae1713a3ec0e150f83900fa1efe)

* `JjoQfIWyFrFsx5aeywnjxPyDrsCDrnP2`
  - Fixes OOM error in kernel
  - built from master (1a86a1d40638067d918f0518975065db4b032f1a)

* `VFwAJmqThGGLrr54Nl6ruzV_CiMzPSsP`
  - Audit rules
  - built from develop (fc09d0ab94d109c2c0137f71ea9977d3d98115e1)

* `VTxOQaMGYbHzG7AvrPPkj6PtObqDXdCN`
  - CIS Stories
  - built from develop (c97a751fe16a8eed79bf62535c3e1783cae5e1b3)

* `rrkMk4sy1rzbR0IhdRACHCNyOPRPCMkY`
  - periodic bump
  - audit rules updates
  - built from develop (bce86bb747294c01c5257b902684110c2f4acb09)

* `8odz7YS4cR0uur4ycxMo5Vtb97pUIIsE`
  - CIS stories
  - built from develop (61d9eebdf6886cf31c7f18e38d16bbb53086267e)

* `H8N6ErQToszmu2MwTxpbpqWfi_g5MrzM`
  - Misc auditd.rules updates
  - built from develop (9d07117264cdf68d82232a3975acb04290cf11ff)

* `D_sAbiMABbzwB6_ziCQJWHmj5c9rnnPT`
  - CIS stories
  - built from develop (c63b0c8b0a6bd9873238e7c717356919a2ec40b6)

* `LtrLWrTXq078WrXvAEJXdvGX.wudoARX`
  - periodic bump
  - built from develop (379493156c63dd8f62e9f69452e37909898fd31f)

* `p1OAjEt9pXYkGDdf7BP7_u81oUYHyuwr`
  - periodic bump
  - built from develop (77e63401fdadb1268aed20d625432de987de1b95)

* `h4Lp7G_o3h3br8NxRWFg8sI_KllY_xc2`
  - periodic bump
  - built from develop (f782166c1fd8b61e49b20db0c632df8af14b32bc)

* `aZd.a1okaHY8Pr41VUUh7rVqyobWhWGG`
  - periodic bump
  - built from develop (f8987838d9f569824b9a1cbc82c9bcf5dcc4b86b)

* `GvskmZQLLH3DL2sV57vQtFdk3Y19EAa3`
  - periodic bump
  - built from develop (2f1540ab7eb2c9eb9cd5003eaf13f046e7b13ad8)

* `bLOLC9NAIukj3gmD1HCP73FLezVNYaTM`
  - periodic bump
  - built from develop (61a9d0dc355aac073dc95d10335ab839fa4dddc3)

* `fJsqdWrUm1v7AY.D8qUr42.4R4Nrnx9f`
  - fix rsyslog/systemd startup
  - restrict dmesg access
  - built from develop (f2519686a6bd7601121b5dccb05c4b210c0ba450)

* `Hxx7ds96bprYfbT1Jd57cbDSGHSL88Oe`
  - Update README to correct path (36622f4)
  - Centos delays the start of rsyslogd using systemd (1c85054)
  - Restrict syslog access via dmesg_restrict=1 sysctl call (94dadb8)
  - Add logic to check if rsyslogd pid file exists before attempting to kill the process by pid (552376b)
  - kill HUP rsyslog upon logrotation (723f589)
  - bump bosh_aws_cpi gem (49bfedf)
  - Fix broken stemcell cis spec on azure (fba40db)
  - Change permissions on agent key to 600 (a9d7d89)
  - built from develop (94dadb8beb7f92d6cd53a4925ff4803699e780b5)

* `m7zyaL24BiYlXuS.Canxzv2AmoKK8A4_`
  - Fix issues with rsyslog
  - built from develop (4e7326cce2afc703440b0198fcad9017ad91caba)

* `cRIqmh9CZLfr3jdgkYpEHsj5yB7Ge5ZS`
  - Update for CIS tests
  - built from develop (04c48a6ec29605b547adcb6f68d02cbaa02a38cd)

* `aL8fvTOVrw5FFakrMEy8kUIebgmqTGwV`
  - default hostname `bosh-stemcell`
  - increase maxkeys, root_maxkeys
  - lower tcp keepalives
  - built from develop (3f1bfcbd90c83455ee8b6c8aea016ef6084b0b0a)

* `fDbsoGyzyAdm47.G4Y_d5pxqKQYAcSGk`
  - periodic bump
  - includes /var/log bind mount to ephemeral partition
  - built from develop (23067ad8d25acde028861aaf659db8a2a43665d9)

* `87OMY2hUCi7ewDzwhSUYGdyt4xd127_z`
  - periodic bump
  - built from develop (124a879424fe144dbc84c43922ef91131edb8f51)

* `RhvGBE_qJSm7CM4gLshNvAHf9zbbNcKc`
  - update for CIS tests
  - built from develop (d858c19af2bf48287f5d192683d9dd606746dadf)

* `3_lwAnVp59D2iUruNsSlEbfa5oBYnTmr`
  - periodic bump
  - update for CIS tests
  - built from develop (d52c3358980dfe2fa21e5c6314633b8e8a06bba8)

* `cjlP5Ciy18FUTcwc9KcmcWETsg7iUPxa`
  - periodic bump
  - update for CIS tests
  - built from develop (bc8683d8c5fd48b2a80d9841c6dd23d4df69256f)

* `.IPDBSu6JIz8v6P7R1kE6gbKqeLufdBv`
  - periodic bump
  - built from develop (fafaffe71b444f444ef8dc9cb95e53d924880b7e)

* `OIJ7Qeu3QZMG3J0rSoI6lx8hdcZfaV5R`
  - update for CIS tests
  - built from develop (99aebc025dc4093981395d75be52369ced2d7131)

* `Nh0.et3GyuktazQ9_jOwJGqByyicDrgV`
  - update for CIS tests
  - built from develop (a8d26078eb4a2fb277068381c76da638f40b5b36)

* `oPXNdD8b5WwJXZZQBEYmdIVT1.Om7z2T`
  - update nginx to 1.11.1
  - built from develop (1af67b94cad42ff2133e383afd6d174721253dbc)

* `ApGJBfSesa7VFhEu3RLRTIqiL1R7E_3J`
  - update for CIS tests
  - built from develop (3dfd04cd65c73a01e2f2f1b7310a33687ab27111)

* `odCwzNL6fL14dOpN4SLDwru.6_LCooLl`
  - USN-2977-1: Linux kernel (Vivid HWE) vulnerability
  - built from develop (ce8e1284890e0079923f26533c0e0f7f6c5b6a0e)

* `YsMYRqAqNEpQPA1bNtE26bg3zH6eR9qP`
  - periodic bump with rsyslog reload changes
  - built from develop (15a4ef77db335b186d183323f5a1f6819c35bdce)

* `IstSjjYJuckEZbTJZ9wcV12hYiX2Nzca`
  - bumped for USN-2959-1: OpenSSL vulnerabilities
  - built from develop (95f5d9cc816f934db64a80188cf0c9e80ab15dda)

* `GvyJwqBPjPEYBVCYrUHp0R7qJUHcTJGD`
  - includes gov1 STIGs
  - built from develop (4bc83146a59ddca85d4a56868e520f938dc84843)

* `zABsJmjq2gQgXzmDmAA7ONmkzNeM4ujN`
  - periodic bump to include STIGs
  - built from develop (a6d4a075ad2c58a629fbc9225d75d67cb4c1cd8a)

* `tH3RcRee0EKRX7RMmELCMEfXXq0ulnik`
  - periodic bump to include STIGs
  - built from develop (51750c70da03484321c7c72346742de257bf2fa5)

* `0M3jbAU705ItzZKPdmh6kxRJR38fmvcf`
  - bumped for libpcre3_1:8.31-2ubuntu2.1 vulnerability
  - built from master (d2f73ee7636f2325bf6998670228682d194627c9)

* `sLe0Rz_sFs0Uy2DcZ9Xf3KQG0QsuUXos`
  - periodic bump to include STIGs
  - built from develop (da0fda1f8bb8ee4c63e64a549bfe3727a6ac5b69)

* `C3YA77iYjAp4OazIG8ZTi7AtPVC6pOY2`
  - periodic bump to include STIGs
  - built from develop (c6c341baee219b90935430ef120f52fce668f496)

* `djw1b9mXYwbOSDPGJoFLktHLv79kbcz_`
  - periodic bump to include STIGs
  - built from develop (597cbcd96e631678f7d66c31e39a2ac7ddc6c89d)

* `w02UF1DU9KaAxqxP_LcLiBp0P1.cZh3T`
  - periodic bump to include STIGs
  - built from develop (7437419b800cdaf2a163fc5606ec360032f37a28)

* `tLeFEoNpFBrwBQbY5jjhOVpAVMSY7UHC`
  - USN-2932-1: Linux kernel (Vivid HWE) vulnerabilities
  - built from master (8f4f73a435acfe6728c2588d55d876476b19b725)

* `.ZN3wb_t45goM3wS4rHRGIamJRCmRsuq`
  - periodic bump

* `2GWd6igY_k.UstpTga8U5nVt6Wh7wQUk`
  - bump kernel to 3.19.0-51

* `MowCFiZ6MRwCv0BrPlXLOm7rBUqo5X7e`
  - USN-2910-1: Linux kernel (Vivid HWE) vulnerabilities
  - built from 3197.1 (ea8b8edc196f6650d4a772bc90e3ee8613056c91)

* `ar7dTtxvhG5d_ytxQ_Js9NDb6ePJV5Jt`
  - update for USN-2900-1: GNU C Library vulnerability
  - includes custom kernel update to fix aufs problem
  - built from 3146.8-os-image (b3122f03ec74c227dad8d6f6c5e730bc4eeafca4)

* `3KSsEYj8q18vJPJfngAjPD2TJqUxwILf`
  - custom kernel update to fix aufs problem
  - built from 3146.7-os-image (fe65269b2a438ce8176639e14e6e1f3a09e16b8b)

* `BzKAbSfWFuIlnIRxEpSkdiHDm53nVwlV`
  - bump for stigs (V-38658)

* `R8M_FtmpgpXpOSGvW_ZHBP0uXGCG1wup`
  - periodic bump

* `OS3dVBJ2.EbaTLC.nRT5LSRScnISW80V`
  - update ubuntu for usn-2871-2

* `6O0I3q10J8CyrSUKgAnFh02dRZFg2HTG`
  - update ubuntu packages for USN-2869-1: OpenSSH vulnerabilities

* `yVt32oA.CXzu2YCXBH7zdttGFdSozka1`
  - update ubuntu packages for USN-2865-1, USN-2861-1

* `fAPEi05GreKek9FEiIGYZKfYPhpPCZ3B`
  - update for USN-2861-1

* `YeywOPDDPX0mn3WgSqpxl1gBXcQhtvWv`
  - bump kernel to 3.19.0-43

* `TTmPhUs6RDJUlQmZ.RYMu0ItfOS6FNtx`
  - update monit from 5.2.4 to 5.2.5

* `3mZuzYe8vUwy3L1YhZihMvJ3OEzpDkj.`
  - update for USN-2854-1

* `b6sz6DaogiiWej6NmGsTM1_TwiDaHjBJ`
  - bump ixgbevf to 3.1.1

* `bfSrIiZ6T8z78QW0rDnQbbfYLxIV2FhS`
  - update for USN-2842-1: Linux kernel vulnerabilities

* `Rp2Py4vqFMAfGkz6mMoT5fu2F9SclVBu`
  - update for USN-2836-1: GRUB vulnerability

* `3Zf3rN5HdZX0nNupFQ8Z1VA2J7ueXzGR`
  - update for USN-2834-1: libxml2 vulnerabilities

* `L6G9dXmF3gVQ2xH5_jTAcENCRGkHbqXB`
  - update for USN-2829-1: OpenSSL vulnerability

* `SxNhu4XpwGJ5O3e6qHMZH4OjIKfAmQxc`
  - changes for stigs (V-38466, V-38465, V-38469, V-38472)

* `Z2HxTjdbITWyRL7GCsY1rVe2OjR0oNRZ`
  - update for USN-2821-1: GnuTLS vulnerability

* `EZerQHXisZiL8zX0zpvivfmC.l6UDST7`
  - update for USN-2820-1: dpkg vulnerability

* `dVVR..kD6eL0RtkFO7d1yBOM6hcZCwkO`
  - update for USN-2815-1: libpng vulnerabilities

* `Y1FdmV9WS39Fx9iJaK7oEuqYFXJgp.cK`
  - update for stigs (V-38548, V-38532, V-38600, V-38601)

* `uVOqUoQtxwXO2.7DVCkRyv_RNSayziQM`
  - update libxml2 for usn-2812-1

* `Nh0G1YGSO8pgwCbOHtvDDTk.Ds.7Yxc_`
  - update for USN-2810-1: Kerberos vulnerabilities

* `MwjwmqQgu7CqpIMECnojJ6VZLiwQhDQz`
  - changes for stigs (V-38523, V-38524, V-38526, V-38529)

* `kNxr8G52rcPMvg5tafh7ldLyAjR3X6g6`
  - changes for blank passwords

* `xMl7HhuREluPZP0YyHZLnxhlHZXrB723`
  - update linux image for USN-2806-1

* `Zibxbt9mNrQnPmgwVXjtVnFJZYiJZT6m`
  - update linux image for USN-2798: kernel (Vivid HWE) vulnerabilities

* `N81hCvgAbYz5JLVlJwpEclmeTegW66qd`
  - update unzip for USN-2788-1: unzip vulnerabilities

* `.4y0e8CHJ4a3mZ3VPpKPAFW3OKxnRmrv`
  - add bosh_sudoers group

* `8LbjKPGE07yEeDNp7RkIRe6xdDI3Jre.`
  - yanked

* `7DQf.gOqy.oQcPBa19sgcbOHcvi458La`
  - yanked

* `L8DtBIngBPbziIOl9UZoyAocxGiUfpdL`
  - yanked

* `Ry5gW034s1xK65YcBEdmuL.ermC3iiE7`
  - yanked

* `t4kWs38oNti4vRrKE9xicElzLb4wCTBm`
  - update kernel for USN-2778-1

* `HU9BVWuGxWwoxJ2jOJYKqDRTjwh419Ig`
  - update kernel for USN-2765-1

* `k74zFOTewcP.k8apaBVH5jS5t87c.IaJ`
  - update rpcbind to 0.2.1-2ubuntu2.2 for USN-2756-1

* `7xLESQCJHkDBRAUr5A6zush.6fZwQ1Dp`
  - update kernel for USN-2751-1

* `Z2u8KpEbHMXu1sYd1lI1VC_RPZGGSYoz`
  - add package for growpart command

* `07SVLfhlpQJWWKphcELs9MV2pwgs1n3y`
  - update ubuntu for FreeType vulnerabilities for USN-2739-1

* `Ty4YAJAYPLWkhtcuJdBytQungO6WXdvu`
  - update kernel for USN-2738-1

* `VUlbpM_lQcwk2XCzQ6.bv1DDLNdQf_mZ`
  - update libexpat and lib64expat for USN-2726-1

* `Y5msN.ChBUBRNvr16rYmtHwjEgKCBaZI`
  - changes for stig

* `1B_yfR3ukFZiCHqopmybOTo13Afq_Nci`
  - update kernel and openssh-server for USN-2718-1 & USN-2710-2

* `EYBafGzUZcQNZ.kwk825bNc.4RUmGGaV`
  - update openssh-server for USN-2710-1

* `UNdcxBFcKRVwhrWu2YQZeJkyiPTItQni`
  - disable single-user mode boot in grub2
  - disable bluetooth module and service

* `RVb_.SznfEzXu3kZuE6BNKSOUtYXlDTR`
  - bump libsqlite3-0 to 3.8.2-1ubuntu2.1

* `pAGNPBUCevAW_h90_tfvW8n3gcsU.Fwr`
  - bump libpcre3 to 1:8.31-2ubuntu2.1

* `kJJV2BteRngZzymVqhbV7rwnsDCfUqRL`
  - update kernel to 3.19.0-25-generic

* `ilfxvb._1aLvgmilbcTGnWoeeL1fq54g`
  - update kernel to 3.19.0-23-generic

* `1YmBmEqA4WqeAv7ImLTh3L3Uka4g0kY9`
  - ssh changes for stig

* `sCkRwPmfK0FfRg8zBGlFNnxmG7rs66KO`
  - update configuration for sshd according to stig

* `SRZf0PiUGIC_AeYmJaxhpS5CbJHsZ5ED`
  - update the ixgbevf driver to 2.16.1

* `Hd33DvSkQIgfJhXz0nNeaYxALZe2O0FO`
  - update kernel to 3.19.0-22-generic

* `D98JkW2IWZ2npUMxo6dzidyf0IL45aUU`
  - update kernel to linux-generic-lts-vivid

* `Ua2BPwAV4jhl0egqdsCGujInYlIpFfGe`
  - update unattended-upgrades to 0.82.1ubuntu2.3

* `DRT11QyZUb3Y.tbS00W3QgAQ_lWMhVYJ`
  - update python to version python3.4 amd64 3.4.0-2ubuntu1.1

* `xLfl7rZVgkXKijjY11rSOGk.AJ8KcmEV`
  - update kernel to 3.16.0-41-generic 3.16.0-41.57~14.04.1

* `mVdBreXVEW3jTtuPMUWm0NaQ2tmEuBkp`
  - update kernel to 3.16.0-41-generic

* `mevqBoryhMFMxQa6.O_7WMsHOjxj8Ypi`
  - update libssl to 1.0.1f-1ubuntu2.15

* `CXy2D8rlo7.asw2H7mzCuUmkzVr30vkc`
  - update kernel to 3.16.0-39-generic

* `DjCfP9Rgj37M0R3ccOOm9._SyF5RipuC`
  - update kernel and packages

* `gXS8tB8AlsACLxca1aOF.A2dJroEW9Wx`
  - update kernel

* `4wantbBiSSKve58dnjaR2wSemOAM7Xiy`
  - upgrade rsyslog to version 8.x (latest version in the upstream project's repo)

* `hdWMpoRhNlIYrwt61zt9Ix2mYln_hTys`
  - remove unnecessary packages to make OS image smaller
  - reduce daily and weekly cron load
  - randomize remaining cronjob start times to reduce congestion in clustered deployments

* `0YARMwfbXRhCyma2hdTZTd97IlZqW3Qc`
  - Add hmac-sha1 to sshd_config (required by go ssh lib)

* `G.Wzs2o9_mu6qvC2Nq7ZUvvo6jJSHjC8`
  - update libgnutls26 to 2.12.23-12ubuntu2.2

* `Hcp6Wc4bQp9WB0i.y_2Z4qYzsO.7AXht`
  - update libssl to 1.0.1f-1ubuntu2.11

* `jU0u9AnG550hgtZhH4TS30eU0lOJZxWn`
  - update libc6 to 2.19-0ubuntu6.6
  - update linux-headers to 3.16.0-31

* `bUE_h7edxT9PNKT6ntBKvXH8MzK3.wiA`
  - update trusty to 14.04.2

* `O6Co_wDMuso7prheiIRVc_Q7_T1sC0EP`
  - upgrade unzip to 6.0-9ubuntu1.3

* `yacqn9ooY2Idc6Fb65QE25zl2MSvPX52`
  - lock down sshd_config permissions
  - disable weak ssh ciphers
  - disable weak ssh MACs
  - remove postfix

* `TjC3SnsvaIhROEa1J1L77Mj21TRikCW0`
  - upgrade unzip to 6.0-9ubuntu1.2

* `xIk.jCEzC5CrI.VrogNsyKRnHBtNIJ1w`
  - Adds kernel flags to enable console output in openstack environments
  - upgrade linux kernel to 3.13.0-45

* `LNYTMCODzn39poV8I4yUg1RxmAfTZPth`
  - upgrade libssl to 1.0.1f-1ubuntu2.8

* `Wxp0XbijOQyo_pYgs3ctYQ0Dc6uPaO.I`
  - switch logrotate to rotate based on size

* `QB8K.uFpJXHYJ4Nm.Of.CALZ_8Vh7sF2`
  - start monit during agent bootstrap

* `shN71hxWcKt1xy54u8H6vcTJX3whZZ1y`
  - disable reverse DNS resolution for sshd

* `VSHa.AirKTKl2thd3d.Ld0LZirE7kK8Z`
  - enable rsyslog kernel logging

* `9_XaaM0qR6ReYHJvyJstqf52IL_1zJOQ`
  - upgrade linux kernel to 3.13.0-39

* `omOTKc0mI6GFkX_HWgPAxfZicfQEvq2B`
  - upgrade bash to 4.3-7ubuntu1.5
  - upgrade libssl to 1.0.1f-1ubuntu2.7

* `qLay8YgGATMjiQZwWv0C26GZ7IUWy.qh`
  - upgrade bash to 4.3-7ubuntu1.4

* `_pB.QMUs1y8oQAvDyjvGI9ccfIOtU0Do`
  - upgrade bash to 4.3-7ubuntu1.3

* `GW4JUpDT_wsDu9TgsDRgXfcNBMVSfziW`
  - upgrade bash to 4.3-7ubuntu1.2

* `9ysc4UIkmhpIhonEJzEeNbIpc8t38KxH`
  - upgrade bash to 4.3-7ubuntu1.1

* `7956UhwNIGtYVKliAcpJFCO7iquWbhQR`
  - install parted

* `cJItjk12ZCUgOo591c10FLHpAcVIwWDZ`
  - update libgcrypt11 to 1.5.3-2ubuntu4.1
  - update gnupg to 1.4.16-1ubuntu2.1

* `P9CaP1LYyF6DBXYWEf0G7mf2qY2z_l1D`
  - update kernel to 3.13.0-35.62 and libc6 to 2.19-0ubuntu6.3

* `pGDuX7KzvJI7sXfGDU5obN8qxcD03e57`
  - update kernel to 3.13.0-34.60

* `EhzrTcjEIEfEBBfcl3dnlBld2ZDjTveA`
  - using latest libssl `1.0.1f-1ubuntu2`

* `KXC8x5eWAI71IOc_IelrkLEGNA6_cjRw`
  - Remove resolv.conf clearing from firstboot.sh
  (3c785776c5093995e66bb1dce3253dfbeec51e40)

* `b8ix9.SJvvOTxDP5kV6cWNdkWpSxY6tn`
  - update kernel to 3.13.0-32.56
  (d2be16d309d891cf4e2fe6ab3c21f4bb8f800c22)

* `kpMtaz33W38LnRuUL_ArWoNKIJwaS6Jb`
  - using latest OpenSSL `1.0.1f`
  (23fe6fcd8518446cbdbec360c2f1e4b37834db88)

* `4oXc4U0orsQS944oCY_am5FqAqHXMhFK`
  - update kernel to 3.13.0.29, updated syslog configuration
  (6927f02e9d3c02e6a7dfdece3d4802704572df2c)

* `ETW9GFwQPNRAknS1SSanJaVA__aL5PfN`
  - swapaccount set, ca certifactes installed
  (f87f2cbd89da47f56e23d15ed232a41178587227)

* `FlU8d.nSgbEqmcr0ahmoTKNbk.lY95uq`
  - Ubuntu 14.04
  (e448b0e8b0967288488c929fbbf953b22a046d1d)