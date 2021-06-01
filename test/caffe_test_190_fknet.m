method = 'fknet';
baseDir = ['../method_190/' method '/'];
model = [baseDir 'FKNet-deploy.prototxt'];
weights = [baseDir 'Trained_Model/FKNet-trained_iter_10000.caffemodel'];
net = caffe.Net(model, weights, 'test');
%w = net.layers('fc190').params(1).get_data();

%% LOAD DATA
subjectNO = 190;
testNO = subjectNO;
setNO = 6;
data_s2 = single(zeros(96,64,3,subjectNO*setNO,1)); %no rotation
for subjectID = 1:subjectNO
    disp(subjectID)
    for setID = 1:setNO
        degree = 0;
        img = caffe.io.load_image(['../data_label_190/data_render2_190_with1_down_s2_ori/subject' num2str(subjectID) '/session2/forefinger/set' num2str(setID) '/img_' num2str(degree) '.bmp']);
        img = img(1+2:100-2,1+3:70-3,:);
        img = repmat(img, [1 1 3]);
        data_s2(:,:,:,(subjectID-1)*setNO+setID) = img;
    end
end
mean_train_data = 126*ones(96,64,3);
test_data = data_s2(:,:,:,:); %select the image without rotate

%% TEST Accuracy
score = zeros(3,3,190,8,8);
score_matrix_test = zeros(subjectNO, testNO*setNO);
for i = 1:testNO*setNO
    disp(i)
    I = test_data(:,:,:,i);
    for shifti = 1:8
        for shiftj = 1:8
            I2 = imtranslate(I,[shifti,shiftj]);
            result = net.forward({I2-mean_train_data});
            score(:,:,:,shifti,shiftj) = result{:};
        end
    end
    I = find(score==max(score(:)));
    [a, b, c, d, e] = ind2sub(size(score),I(1));
    score_matrix_test(:,i) = score(a,b,:,d,e);
end
save('score_matrix_test.mat','score_matrix_test')
    

%% Evaluation
score_matrix = -score_matrix_test(1:testNO,:);
score_matrix2GI_scores
ROC
