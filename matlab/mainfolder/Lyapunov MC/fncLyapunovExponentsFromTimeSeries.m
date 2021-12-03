function ly = fncLyapunovExponentsFromTimeSeries(timeSeries, delay, emb, time)

    M = 500;

    lambda = 0;
    ts = size(timeSeries);

    % �����x�N�g���̌���
    A = timeSeries(1:delay:1 + (emb-1) * delay);

    % A�̋ߖT�_��T��
    tmpTime = ts(1) + 1 - emb*delay - 100;
    tmpA = zeros(tmpTime - 1, emb);
    
    for i = 1:emb
        tmpA(:, i) = timeSeries(2 + delay*(i-1):tmpTime + delay*(i-1));
    end

    tmpAsize = size(tmpA);
    
    idx = knnsearch(tmpA(1:tmpAsize(1)-time*2,:),A');    
    dashA = tmpA(idx,:)';
    dashTime = idx;  
        
    for k = 1 : time : M*time

        % A�ƋߖT�_A'�̋������v�Z
        L = norm(A - dashA);

        % time��̃x�N�g��B��B'
        B = timeSeries(k + time:delay:k + time + (emb-1) * delay);
        dashB = tmpA(dashTime+time,:)';
        
        % B�ƋߖT�_B'�̋������v�Z
        dashL = norm(B - dashB);

        lambda = lambda + log2(dashL/L);
        
        % L'�̐��K���_���v�Z
        normlizeL = (B - dashB) / dashL;
        normlizeL = B - normlizeL;
                
        % B��B'�̍ŋߖT�_����B''��T��(���̎��Ԃ�A')
        tmpA = zeros(tmpTime, emb);

        for i = 1:emb
            tmpA(:, i) = timeSeries(1 + delay*(i-1):tmpTime + delay*(i-1));
        end
        
        tmpA(k+time, :) = zeros(1, emb);
        
        idx = knnsearch(tmpA(1:tmpAsize(1)-time*2,:),normlizeL');    
        dashA = tmpA(idx,:)';
        dashTime = idx;  
                
        % B�����̎��Ԃ�A�Ƃ���
        A = B;
    end
    
    % �Ō�Ɍv�Z
    ly = lambda / (M * time);

end