function dist = mindist(K,DATA)
mind = zeros(K*(K-1)/2,1);
p = 1;

for i = 1:(K-1)
    for j = (i+1):K
    
      D1 = DATA(:,:,i);
      D1(~any(D1,2),:) = [];
      D2 = DATA(:,:,j);
      D2(~any(D2,2),:) = [];
      mind(p,1) = distance(D1(1,:),D2(1,:)); 
      for i1 = 1:size(D1,1)
        for j1 = 1:size(D2,1)
              d = distance(D1(i1,:),D2(j1,:));
              if(d<mind(p,1))
                mind(p,1) = d;
              endif
        endfor
      endfor  
      p++;
      
    endfor
endfor  


dist = min(mind);

end