%session2_short_and_roc

%% Transfer full matrix into short(subject) matrix
    image_NO = setNO;%6
    subject_NO = size(score_matrix,1);
    short_score_matrix = score_matrix;
    %{
    subject_NO = size(score_matrix,1)/image_NO;

    short_score_matrix = zeros(subject_NO,subject_NO*image_NO);
    for i=1:image_NO:size(score_matrix,1)
        for j=1:size(score_matrix,2)
            vector = score_matrix(i:i+image_NO-1,j);
            short_score_matrix(ceil(i/image_NO),j) = min(vector);
        end
    end
    %}
    
    %% ROC ALL
    %{
    set_NO = 6;
    
    counter_genuine = 1;
    counter_imposter = 1;
    for i=1:size(score_matrix,1)
        for j=1:size(score_matrix,2)
            subjectID = ceil(i/set_NO);
            %setID = mod(i,set_NO); if(setID==0) setID=set_NO; end
            subjectID_2 = ceil(j/set_NO);
            %setID_2 = mod(j,set_NO); if(setID_2==0) setID_2=set_NO; end
            
            if(subjectID == subjectID_2)
                D_genuine(counter_genuine) = score_matrix(i,j); %Challenging
                counter_genuine = counter_genuine + 1;
            else
                D_imposter(counter_imposter) = score_matrix(i,j); %Challenging
                counter_imposter = counter_imposter + 1;
            end
        end
    end
    save('D_genuine.mat','D_genuine');
    save('D_imposter.mat','D_imposter');
    %[min(D_genuine) max(D_genuine)]
    %hist(D_genuine)
    %[min(D_imposter) max(D_imposter)]
    %hist(D_imposter)
    %}
    
    %% ROC Short
    set_NO = image_NO;
    D_genuine = zeros(1,subject_NO*set_NO);
    D_imposter = zeros(1,subject_NO*(subject_NO-1)*set_NO);
    counter_genuine = 1;
    counter_imposter = 1;
    for i=1:size(short_score_matrix,1)
        for j=1:size(short_score_matrix,2)
            subjectID = i;
            %setID = mod(i,set_NO); if(setID==0) setID=set_NO; end
            subjectID_2 = ceil(j/set_NO);
            %setID_2 = mod(j,set_NO); if(setID_2==0) setID_2=set_NO; end
            
            if(subjectID == subjectID_2)
                D_genuine(counter_genuine) = short_score_matrix(i,j); %Challenging
                counter_genuine = counter_genuine + 1;
            else
                D_imposter(counter_imposter) = short_score_matrix(i,j); %Challenging
                counter_imposter = counter_imposter + 1;
            end
        end
    end
    mkdir('temp');
    save('temp/D_genuine.mat','D_genuine');
    save('temp/D_imposter.mat','D_imposter');
    
    a = min([D_genuine D_imposter]);
    b = max([D_genuine D_imposter]);
    subplot(2,1,1)
    hist(D_genuine,100)
    xlim([a b])
    subplot(2,1,2)
    hist(D_imposter,100)
    xlim([a b])
    print('temp/distribution1','-dtiffn')
    close
    %ksdensity(D_genuine)
    %hold on
    %ksdensity(D_imposter)
    %print('distribution2','-dtiffn')
    %close
 