clear;close all;clc;
tic;
string = input('Input the data file -->> ','s');
data = load(string);
if(yes_or_no('Do you have labels in your data file?'))
data(:,columns(data)) = []; %deleting the label column of the data
endif
data = data(randperm(rows(data)),:); %randomise the data
data = normalize(data);
range_of_K = input('Upto which K,you want to measure the Dunn index ');

for K = 2:range_of_K
max_iter = 1000;   % can change it later

index = randperm(rows(data))(1:K);

for i = 1:K
  cluster(i,:) = data(index(i),:);  %k number of cluster center is taken,which are actually any random data points
endfor

for j = 1:max_iter
  clusterCheck = cluster;
  count = zeros(K,1); %to count the number of data points in each clusters in every iterations
  clusterSum = zeros(K,columns(data));
  for i = 1:rows(data)
      for k = 1:K
          d(k,:) = distance(data(i,:),cluster(k,:)); %to calculate the distance from the data points to present cluster centers 
      endfor 
      for k = 1:K
         if(min(d) == d(k,:)) 
           clusterIndex(i,:) = k; %assigning the data example to a particular cluster center
           clusterSum(k,:) = clusterSum(k,:) + data(i,:);
           count(k,:)++;
         endif  
      endfor    
  endfor
  
  for k = 1:K
  cluster(k,:) = clusterSum(k,:)/count(k,:); %For next iteration,cluster center is changed to the mean of the data points for individual clusters
  endfor
  
  movement_of_clustercenters = 0;
  for k = 1:K
  movement_of_clustercenters = movement_of_clustercenters + distance(cluster(k,:),clusterCheck(k,:));
  endfor
  
  if(movement_of_clustercenters == 0)
  break
  endif
endfor

assignedCluster = [data';clusterIndex']';

for k = 1:K
 p = 1;
  for i = 1:rows(data)
    if(clusterIndex(i,1) == k)
      for j = 1:columns(data)
        DATA(p,j,k) = data(i,j);
      endfor
      p++;
    endif
  endfor
endfor




max_diameter = maxdiam(K,DATA); % max_diameter is the diameter of the cluster which has the maximum diameter
min_distance_between_clusters = mindist(K,DATA); % min_distance_between_clusters is the minimum of all the distances between all the clusters 
Dunn_Index(K,1) = min_distance_between_clusters/max_diameter;
clear('DATA','cluster','clusterIndex','clusterSum','i','j','k','d','count','max_diameter','min_distance_between_clusters','p','index','assignedCluster');

endfor
[~,finalK] = max(Dunn_Index);
printf('Maximum Dunn Index found for K = %d\n',finalK);
printf('This K will be used for final clustering\nProgram paused,Press Enter for final Clustering \n');
pause;
K = finalK;


index = randperm(rows(data))(1:K);
for i = 1:K
  cluster(i,:) = data(index(i),:);  %k number of cluster center is taken,which are actually any random data points
endfor


for j = 1:max_iter
  clusterCheck = cluster;
  count = zeros(K,1); %to count the number of clusters in every iterations
  clusterSum = zeros(K,columns(data));
  for i = 1:rows(data)
      for k = 1:K
          d(k,:) = distance(data(i,:),cluster(k,:)); %to calculate the distance from the data points to present cluster centers 
      endfor 
      for k = 1:K
         if(min(d) == d(k,:)) 
           clusterIndex(i,:) = k; %assigning the data example to a particular cluster center
           clusterSum(k,:) = clusterSum(k,:) + data(i,:);
           count(k,:)++;
         endif  
      endfor    
  endfor
  
  
  for k = 1:K
  cluster(k,:) = clusterSum(k,:)/count(k,:); %For next iteration,cluster center is changed to the mean of the data points for individual clusters
  endfor
  
  movement_of_clustercenters = 0;
  for k = 1:K
  movement_of_clustercenters = movement_of_clustercenters + distance(cluster(k,:),clusterCheck(k,:));
  endfor
  
  if(movement_of_clustercenters == 0)
  break
  endif
  
endfor

assignedCluster = [data';clusterIndex']';



printf('The number of data points in individual clusters = \n');
count
printf('Program paused,Press Enter to continue\n');
pause;

for k = 1:K
 p = 1;
  for i = 1:size(data,1)
    if(clusterIndex(i,1) == k)
      for j = 1:size(data,2)
        DATA(p,j,k) = data(i,j);
      endfor
      p++;
    endif
  endfor
endfor

if(yes_or_no('Do you want to print all the data points of each clusters? '))
p = 1;
for k = 1:K
D = DATA(:,:,k);
D(~any(D,2),:) = [];
printf("\nPoints assigned to cluster %d=\n",k);
D 
endfor
endif

if(columns(data)==2)
cmap = hsv(K);
for k = 1:K
D = DATA(:,:,k);
D(~any(D,2),:) = [];
plot(D(:,1),D(:,2),'o','Color',cmap(k,:));
hold on;
endfor
endif

toc;