    %% Evaluation1 (combined ROC of 3 tests)
    disp('Evaluation');
    
    v_length = 2000;
    TPR = zeros(1,v_length+1);
    FPR = zeros(1,v_length+1);
    db_count = 1;
    progress_count = 0;
    for decision_boundary = min(D_genuine):(max(D_imposter)-min(D_genuine))/v_length:max(D_imposter) %limit by imposter size: 1/size(D_imposter,2)
        TP = length(find(D_genuine <= decision_boundary));
        FN = length(D_genuine) - TP;
        FP = length(find(D_imposter <= decision_boundary));
        TN = length(D_imposter) - FP;
        
        TPR(db_count) = TP/(TP+FN);
        FPR(db_count) = FP/(FP+TN);
        db_count = db_count + 1;
    end
    
    plot(FPR,TPR);
    set(gca,'Xscale','log');
    set(gca,'xlim',[min([nonzeros(FPR); 10^-1]), 10^0]);
    title('Receiver operating characteristic')
    xlabel('False acceptance rate')
    ylabel('Genuine acceptance rate')
    
    %Extend
    %{
    hold on
    plot(FPR,TPR,'m-*','DisplayName',['Ours-NVD: EER = ' num2str(EER)]);
    legend('off')
    legend('show')
    %}
    
    %% EER
    Distance = ones(1, size(FPR,2));
    FNR = 1-TPR;
    for i=1:size(FPR,2)
        if(FPR(i)~=1 && FNR(i)~=1)
            Distance(i) = abs(FPR(i)-FNR(i));
        end
    end
    [temp idx] = min(Distance);
    EER = mean([FPR(idx) FNR(idx)])
    legend(['EER = ' num2str(EER)],'Location','southeast')
    print('temp/roc','-djpeg')
    
    threshold = min(D_genuine)+0.0001*(idx-1);
    save('temp/roc.mat','FPR','TPR','EER','threshold')