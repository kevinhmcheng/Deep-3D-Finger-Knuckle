This folder provides the 3D finger knuckle images, the network model and the implementation codes for the experiments described in [1].
The details on the 3D finger knuckle images database can also be observed in [2].

Training Stage
To generate the lmdb file, you may run the following command in /data_label_190:
/caffe-master/build/tools/convert_imageset --shuffle --backend=lmdb ./ ./label_render2_190_with1_down_center_rot2_s1.txt ./lmdb_label_render2_190_with1_down_center_rot2_s1

To train the network, you may run the following command in /method_190/fknet:
/caffe-master/build/tools/caffe train --solver=FKNet-solver.prototxt --weights=ResNet-50-model.caffemodel 2>&1 | tee log.log

Testing Stage
To evaluate to test sample, you may run the following code in /test:
caffe_test_190_fknet.m


References:
[1] Kevin H. M. Cheng and Ajay Kumar. Deep Feature Collaboration for Challenging 3D Finger Knuckle Identification. IEEE Transactions on Information Forensics and Security, (T-IFS), 16, pp.1158-1173, 2021.
[2] Kevin H. M. Cheng and Ajay Kumar. Contactless Biometrics Identification using 3D Finger Knuckle Patterns. IEEE Transactions on Pattern Analysis and Machine Intelligence, 42(8), pp.1868-1883, 2020.


Due to the size limitation, please download the trained model weights via:
https://www4.comp.polyu.edu.hk/~cshmcheng/files/code/TIFS20.zip
