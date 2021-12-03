function ly = fncLyapunovExponentsFromTimeSeries(timeSeries, delay, emb, time)

    M = 500;

    lambda = 0;
    ts = size(timeSeries);

    % 初期ベクトルの決定
    A = timeSeries(1:delay:1 + (emb-1) * delay);

    % Aの近傍点を探す
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

        % Aと近傍点A'の距離を計算
        L = norm(A - dashA);

        % time後のベクトルBとB'
        B = timeSeries(k + time:delay:k + time + (emb-1) * delay);
        dashB = tmpA(dashTime+time,:)';
        
        % Bと近傍点B'の距離を計算
        dashL = norm(B - dashB);

        lambda = lambda + log2(dashL/L);
        
        % L'の正規化点を計算
        normlizeL = (B - dashB) / dashL;
        normlizeL = B - normlizeL;
                
        % BとB'の最近傍点からB''を探す(次の時間のA')
        tmpA = zeros(tmpTime, emb);

        for i = 1:emb
            tmpA(:, i) = timeSeries(1 + delay*(i-1):tmpTime + delay*(i-1));
        end
        
        tmpA(k+time, :) = zeros(1, emb);
        
        idx = knnsearch(tmpA(1:tmpAsize(1)-time*2,:),normlizeL');    
        dashA = tmpA(idx,:)';
        dashTime = idx;  
                
        % Bを次の時間のAとする
        A = B;
    end
    
    % 最後に計算
    ly = lambda / (M * time);

end