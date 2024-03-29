clc; clear all; close all;
tic;
%%%%%%%%%%% Initilizing General Variables %%%%%%%%%%%%%%%%%
R = 250; %radius of circle
Range = 200; %transmission range of nodes
N = 100; %number of nodes
max_step=100; % maximum itrations in SA
Degree=zeros(1,N);
plot_test=zeros(1,max_step);
avg=1;
fitness_func_R=0;
s=(N*(N+1))/2; % Size of choromosome
no_of_chrom=20;
pop_members=no_of_chrom/2; %number of members in a population
chrom(1,s)=0; %initializing chromosome generalize
chrom_pop(1,s)=0; %initializing chromosome for population 1
pop1_chrom(pop_members,s)=0; %chromosome matrix of population 1
chrom_test(N,N)=0; %initilaizing matrix to save 3x3 into 2x2 matrix for chromosome generation
neighbour_limit=60; %no of neighbours each node can form
degree_check(1,N)=0;% to check degree of nodes in a adjacency matrix
B_D(N,N,no_of_chrom)=0; %initializing 3D matrix for storing adjacency matrix of population
threshold= 0.3; % threshhold or PChange for mutation
imax=100; %maximum itrations
schineder_R_imax(imax)=0;
aplha=0.8; % to calculate Ti from To in SA
alpha=0.9;
for xx=1:avg
%%%%%%%%%%%%%% Start cirle with diameter 500m, for defining field
t=0:pi/500:2*pi; 
x1=R*cos(t);
y1=R*sin(t);

plot(x1,y1,'r', 'LineWidth',2.0)
xlabel('Diameter (meters)');
ylabel('Diameter (meters)');
hold on;
%%%%%%%%%%%%% End cirle with diameter 500m, for defining field
distance= @(x,y) sqrt(((x.xd-y.xd)^2) + ((x.yd-y.yd)^2)); %Calculating Ecladian Distance

for i=1:N
    r=R;
    th=2*pi;
    r=r * rand ;
    th=th * rand ;
    x=r*(cos(th));
    y=r*(sin(th));
%%%% Start cirle with radius 200m, for defining nodes range    
    th = 0:pi/50:2*pi;
    xunit = Range * cos(th) + x;
    yunit = Range * sin(th) + y;
    plot(xunit, yunit, 'g', 'LineWidth',0.5);
    hold on
%%%% End cirle with radius 200m, for defining nodes range
    S(i).xd=x;
    S(i).yd=y;
    S(i).Nei= [];
    plot(S(i).xd,S(i).yd,'b.','MarkerSize',10)
    hold on
end

plot(x1,y1,'r', 'LineWidth',2.0)
hold on
plot(S(i).xd,S(i).yd,'b.','MarkerSize',10)
for i=1:N
    index=1;
    for j=1:N
           if i~=j
                distance_with_node =  distance(S(i),S(j));
                %if distance_with_node <= Range && numel(S(i).Nei)~=10
                if distance_with_node <= Range 
                    S(i).Nei (index)= j;
                    index=index+1;
                    hold on
                end               
           end
    end   
end

%%%%%%%%%%%%%%%%%%%%% Start of Adjacency Matrix %%%%%%%%%%%%%%%%%%%%
for i=1:N
    for j=1:N
        Member_check = ismember(i, S(j).Nei(:));
        if Member_check == 0
            A(i,j) = 0;
        else
            A(i,j) =1;
        end
    end
    Degree(i)=numel(S(i).Nei);
end
%%%%%%%%%%%%% End of Adjacency Matrix %%%%%%%%%%%%%%% 
%%%%%%%%%%%%% Start of Charomosome %%%%%%%%%%%%%%%%
j=1;
k=1;
l=N;
for i=j:N
  for m=j:N
    A(j,m);
     chrom(1,k)= A(j,m); % generating charomosome of orignal topology
     k=k+1;
  end
  j=j+1;    
end
%%%%%%%%%%%%% End of Charomosome %%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%% Multiple Neighbours 3D Matix %%%%%%%%%%%%
B_D(:,:,1)=A; %storing orignal topology in 1st position of population
for k=2:no_of_chrom    %filling 2nd to 19th topologies in population 
    B_D(:,:,k)=A;
    for j=1:N
        degree_check(1,j)= sum(B_D(j,:,k));
        while degree_check(1,j) > neighbour_limit %applying edge limit n topology over population
            B_D(j,ceil(rand(1)*N),k)=0;     %deleting random edge from adjacency matrix for randomization        
            degree_check(1,j)= sum(B_D(j,:,k));
        end        
    end    
end


%%%%%%%%%%%%%%%%%%%%%%%%   Generating 1st population  %%%%%%%%%%%%%%%%%%
for i=1:pop_members %pop_members is limit of number of members in population
    pop1_adj(:,:,i)=B_D(:,:,i);    %saving first half of B_D in pop1_adj    
end  
%%%%%%%%%%%%%%%%%%% Chromosomes of 1st Population %%%%%%%%%%%%%%%%%%%%%%%%
for i=1:pop_members
    for j=1:N
            for k=1:N
                x=pop1_adj(j,k,i);
                chrom_test(j,k)=x;  
    
            end
    end
%%%%%%%% Choromosome converstion of adjacency matrix of chrom_test %%%%%%%%
j1=1;
k1=1;
l1=N;
for i1=j1:N
  for m1=j1:N
    A(j1,m1);
     chrom_pop(1,k1)= chrom_test(j1,m1); % generating charomosome of orignal topology
     k1=k1+1;
  end
  j1=j1+1;    
end    
pop1_chrom(i,:)=chrom_pop(1,:);    
    
 end

%%%%%%%%%%%  Generating 2nd population  %%%%%%%%%%%%%

for i=1:pop_members
    
    pop2_adj(:,:,i)=B_D(:,:,i+pop_members); %saving second half of B_D in pop2_adj
end  

%%%%%%% Chromosomes of 2nd Population %%%%%%%
%%%%%%%%%%%%%%%%%%% Chromosomes of 1st Population %%%%%%%%%%%%%%%%%%%%%%%%
for i=1:pop_members
    for j=1:N
            for k=1:N
                x=pop2_adj(j,k,i);
                chrom_test(j,k)=x;  
    
            end
    end
    %%%%%%%%choromosome converstion of adjacency matrix of chrom_test %%%%%%%%
j1=1;
k1=1;
l1=N;
for i1=j1:N
  for m1=j1:N
    A(j1,m1);
     chrom_pop(1,k1)= chrom_test(j1,m1); % generating charomosome of orignal topology
     k1=k1+1;
  end
  j1=j1+1;    
end    
pop2_chrom(i,:)=chrom_pop(1,:);   
end
%%%%%%%%%%%%%%%%%%%%%%% Itrations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
schineder_R1(1,10)=0; % for saving R values of pop1
schineder_R2(1,10)=0; % for saving R values of pop2
schineder_R_imax(1,imax)=0; % for saving R values of all itrations
SA=pop1_adj;
for o=1:imax 
c(100,100)=0;
    %%%%% Calculating R for 1st population %%%%%%%%
    for n=1:pop_members %pop_members is limit of number of members in population
        c=pop1_adj(:,:,n);    %sconverting 3D matrix into 2D matric for calculation of R    
  
            for k=1:N
                degree_R(k)=sum(c(:,k));    %%degree calculation of matrix C, ready for calculation of schineder R
            end

    %%%%%%%%%%%%%%%%%%%% Calculating R   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Calculating Maximum Degree Node %%%%%%%%%%%%%%%%
    [max_num,max_idx] = max(degree_R(:));
    max_idx;
    %%%%%%%%%%%% Deleting Maximum Degree Node %%%%%%%%%%%%%%%%%%
    A_D=c;
    A_D(:,max_idx)=0;
    A_D(max_idx,:)=0;
    %%%%%%%%% Finding 2nd Maximum degree %%%%%%%%%%%%%%%%%%%%%%%
    second_Degree(1,N)=0;
    for i=1:N
        for j=1:N
            second_Degree(j)= sum(A_D(:,j));
        end
    end
    [second_max_num,second_max_idx] = max(second_Degree(:));
    second_max_idx;
    %%%%%%%%%%%%%% Finding 90% Degrees in Comparison to Maximum degree %%%%%
    ninty_percent_max_degree=(max_num/100)*90;
    ninty_percent_threshold=0;
    num_ninty_percent_nodes=0;
   for j=1:N
        if second_Degree(j)>= ninty_percent_max_degree;
           num_ninty_percent_nodes= num_ninty_percent_nodes+1;
        end
   end
    num_ninty_percent_nodes;
    %%%%%%% Calculating Fittness Function R %%%%%%%
    fitness_func_R= num_ninty_percent_nodes/N;
     schineder_R1(n)=fitness_func_R;
     schineder_R1(n);
%%%%%%%%%%%%%%%%%%%%%% End of R  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    end %% end of pop1 limit
    
    
    %%%%% calculating R for second population %%%%%%
   for n=1:pop_members %pop_members is limit of number of members in population
        c=pop2_adj(:,:,n);    %sconverting 3D matrix into 2D matric for calculation of R    
  
            for k=1:N
                degree_R(k)=sum(c(:,k));    %%degree calculation of matrix C, ready for calculation of schineder R
            end

    %%%%%%%%%%%%%%%%%%%% Calculating R   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Calculating Maximum Degree Node %%%%%%%%%%%%%%%%
    [max_num,max_idx] = max(degree_R(:));
    max_idx;
    %%%%%%%%%%%% Deleting Maximum Degree Node %%%%%%%%%%%%%%%%%%
    A_D=c;
    A_D(:,max_idx)=0;
    A_D(max_idx,:)=0;
    %%%%%%%%% Finding 2nd Maximum degree %%%%%%%%%%%%%%%%%%%%%%%
    second_Degree(1,N)=0;
    for i=1:N
        for j=1:N
            second_Degree(j)= sum(A_D(:,j));
        end
    end
    [second_max_num,second_max_idx] = max(second_Degree(:));
    second_max_idx;
    %%%%%%%%%%%%%% Finding 90% Degrees in Comparison to Maximum degree %%%%%
    ninty_percent_max_degree=(max_num/100)*90;
    ninty_percent_threshold=0;
    num_ninty_percent_nodes=0;
   for j=1:N
        if second_Degree(j)>= ninty_percent_max_degree;
           num_ninty_percent_nodes= num_ninty_percent_nodes+1;
        end
   end
    num_ninty_percent_nodes;
    %%%%%%% Calculating Fittness Function R %%%%%%%
    fitness_func_R= num_ninty_percent_nodes/N;
     schineder_R2(n)=fitness_func_R;
     schineder_R2(n);
%%%%%%%%%%%%%%%%%%%%%% End of R  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    end %% end of pop1 limit


   %%%%% End of Schiender R for Second Population %%%%%%%
   
%%%%% Finding minimum R in Pop1 and Pop2 %%%%%%
[min_num,min_idx] = min(schineder_R1(:));
Father_R=min_num;
F_index=min_idx;
%F_Topology= pop1_adj(:,:,F_index);
F_Topology= pop1_adj(:,:,ceil(rand(1)*10));
[min_num,min_idx] = max(schineder_R2(:));
Mother_R=min_num;
M_index=min_idx;
%M_Topology=pop2_adj(:,:,M_index);
M_Topology=pop2_adj(:,:,ceil(rand(1)*10));


%%%%%%%%%%%%%%%% Start of CrossOver %%%%%%%%%%%%%%%%%%%%%%%%
Degree_F_Topology_Real=sum(F_Topology,1); %%% Calculate degree of each node in Father Topology
Degree_M_Topology_Real=sum(M_Topology,1);   %%% Calculate degree of each node in Mother Topology
Diff=F_Topology - M_Topology;               
[row,col]=find(Diff==1);
F_Exclusive_edges=[row,col];                %%% Calculate Father's Exclusive edges
Diff1=M_Topology - F_Topology;
[row1,col1]=find(Diff1==1);
M_Exclusive_edges=[row1,col1];              %%% Calculate Mother's Exclusive edges
F_Topology_temp=F_Topology;
M_Topology_temp=M_Topology;
F_Topology_new=F_Topology;
M_Topology_new=M_Topology;
linearInd_M = sub2ind(size(F_Topology_temp),[F_Exclusive_edges(:,1)],[F_Exclusive_edges(:,2)]);
M_Topology_new([linearInd_M])=ones(1,length(linearInd_M));      %%% Calculate Daughter Topology by incorporating Father's exclusive edges
linearInd_F = sub2ind(size(M_Topology_temp),[M_Exclusive_edges(:,1)],[M_Exclusive_edges(:,2)]);
F_Topology_new([linearInd_F])=ones(1,length(linearInd_F));      %%% Calculate Son Topology by incorporating Mother's exclusive edges
Degree_M_Topology_new=sum(M_Topology_new,1);        %%% Calculating Degree of Daughter Topology
Degree_F_Topology_new=sum(F_Topology_new,1);        %%% Calculating Degree of father Topology
dgr=1;
for i=1:1
while(dgr~=0)
if Degree_F_Topology_new(i) > Degree_F_Topology_Real(i)
    index = randi(10000,1);
%     B=F_Topology_new.';
    new_index=index;
if ~ismember(index,linearInd_F(:)) && F_Topology_new(index)~=0
	F_Topology_new(index) = 0;
end
elseif Degree_F_Topology_new(i) < Degree_F_Topology_Real(i)
	index = randi(10000, 1);
	F_Topology_new(index) = 1;
end
Degree_F_Topology_new=sum(F_Topology_new,1);
Degree_Diff(i) = (Degree_F_Topology_new(i)-Degree_F_Topology_Real(i));
if Degree_Diff(i) == 0
    dgr=0;
%     i=i+1;
end
end
dgr=1;
end
M_Topology_new;
F_Topology_new;

%%%%%%%%%%%%%%%% End of CrossOver %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Start of Mutation SON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mutat_adj_son(N,N)=0;
mutat_adj_son=F_Topology_new;

%%%%%%% Calculate Degree of complete matix under mutation %%%%%%%%
for k=1:N
  mutat_degree(k)=sum(mutat_adj_son(:,k));    
end
%%%% calculating first maximum degree node for mutation
[max_num,max_idx] = max(mutat_degree(:));
node1_index= max_idx;
node1_degree= max_num;

%%%% calculating second maximum degree node for mutation
mutat_degree_second=mutat_degree;
mutat_degree_second(max_idx)=0;
[max_num,max_idx] = max(mutat_degree_second(:));
Member_check=0;
for i=1:N
    
    if Member_check<mutat_degree_second(i)
        if mutat_adj_son(node1_index,i)==0
            if mutat_adj_son(i,node1_index)==0
        node2_index=i; 
        node2_degree=mutat_degree_second(i);
            end
        end
    end
end
node2_index;
node2_degree;
 
%%%%% Calculating partner of node 1 %%%%%
degree_member_check=0;
node1_neighbour_degree=0;
node1_neighbour_index=0;
for i=1:N

    Member_check =mutat_adj_son(i,node1_index);

    if Member_check == 1 && i~=node2_index && i~=node1_index%checking edges of node 1
       if mutat_adj_son(i,node2_index)==0
           
                degree_member_check=sum(mutat_adj_son(:,i)); %if edge exists with any node then calculate degree of that node
                if node1_neighbour_degree<degree_member_check
                    node1_neighbour_degree= degree_member_check ;
                    node1_neighbour_index=i;
                end
           
        end
    end
end
node1_neighbour_index;
node1_neighbour_degree;


%%%% Calculating partner of node 2 %%%%%
degree_member_check=0;
node2_neighbour_degree=0;
node2_neighbour_index=0;
for i=1:N

    Member_check =mutat_adj_son(i,node2_index);
%    Member_check = ismember(i, node2_index); %%check all rows of node2_index
    if Member_check == 1  
        if mutat_adj_son(i,node1_index)==0 
            if mutat_adj_son(i,node1_neighbour_index)==0 %checking edges of node 1
                degree_member_check=sum(mutat_adj_son(:,i)); %if edge exists with any node then calculate degree of that node
                    if node2_neighbour_degree<degree_member_check
                        node2_neighbour_degree= degree_member_check ;
                        node2_neighbour_index=i;
                    end
            end
        end
    end
end
node2_neighbour_index;
node2_neighbour_degree;

%% Sorting Degrees of Node 1, Node 2, Node 1 neighbour, Node 2 neighbour %%

sort_array = zeros(1,4);       
sort_array(1)=node1_degree;
sort_array(2)=node2_degree;
sort_array(3)=node1_neighbour_degree;
sort_array(4)=node2_neighbour_degree;
sorting=sort(sort_array);
di=node1_degree;
dj=node2_degree;
dk=node1_neighbour_degree;
dl=node2_neighbour_degree;
d1=sorting(4);
d2=sorting(3);
d3=sorting(2);
d4=sorting(1);

d1;
d2;
d3;
d4;

%%%%%%%%%%%%%%%%%%%%%%% End of Sorting Degrees %%%%%%%%%%%%%%%%%%%%%
        
s1=(d1-d2)+(d3-d4);
s2=abs((di-dj)+(dk-dl));
p=s1/s2;

if p<threshold
node1_index;
node1_degree;
node2_index;
node2_degree;
node1_neighbour_index;
node1_neighbour_degree; 
node2_neighbour_index;
node2_neighbour_degree;

if node2_neighbour_index==0
    node2_neighbour_index=node2_neighbour_index+1;
end

mutat_degree;
mutat_adj_son(node1_index,node2_index)=1; %%making edge between node i and node k
mutat_adj_son(node2_index,node1_index)=1; %%making edge between node k and node i
mutat_adj_son(node1_neighbour_index,node2_neighbour_index)=1; %%making edge between node j and node l
mutat_adj_son(node2_neighbour_index,node1_neighbour_index)=1; %%making edge between node l and node j
for k=1:N
  mutat_degree_2(k)=sum(mutat_adj_son(:,k));    %%degree calculation after formation of new edges by mutation between i and k,  j and l
end

%%%%% Equalization  of Degree After Mutation %%%%%%%%%%
mutat_degree_3=mutat_degree_2;  
for i=1:N
    
    if i~=node2_index
        if mutat_degree_3(node1_index)>mutat_degree(node1_index)
            if mutat_adj_son(i,node1_index)==1 %checking edges of node 
                mutat_adj_son(i,node1_index)==0;
                x=mutat_degree_3(node1_index)-1;
                mutat_degree_3(node1_index)=x;
            end
        end
    end
    if i~=node1_index
        if mutat_degree_3(node2_index)>mutat_degree(node2_index)
            if mutat_adj_son(i,node2_index)==1 %checking edges of node 
                mutat_adj_son(i,node2_index)==0;
                x=mutat_degree_3(node2_index)-1;
                mutat_degree_3(node2_index)=x;
            end
        end
    end
    if i~=node2_neighbour_index
        if mutat_degree_3(node1_neighbour_index)>mutat_degree(node1_neighbour_index)
            if mutat_adj_son(i,node1_neighbour_index)==1 %checking edges of node 
                mutat_adj_son(i,node1_neighbour_index)==0;
                x=mutat_degree_3(node1_neighbour_index)-1;
                mutat_degree_3(node1_neighbour_index)=x;
            end
        end
    end   
    if i~=node1_neighbour_index
        if mutat_degree_3(node2_neighbour_index)>mutat_degree(node2_neighbour_index)
            if mutat_adj_son(i,node2_neighbour_index)==1 %checking edges of node 1
                mutat_adj_son(i,node2_neighbour_index)=0;
                x=mutat_degree_3(node2_neighbour_index)-1;
                mutat_degree_3(node2_neighbour_index)=x;
            end
        end
    end   
end
mutat_adj_son;
%%%% End of Degree Equalization %%%%%%%   

%%%% Re Degree Calculation after equaliztion of degree %%%%%%
for k=1:N
  mutat_degree_4(k)=sum(mutat_adj_son(:,k));    %%degree calculation after deletion of extra edges
end

end  %%% End of p< threshold condtion
%%%%%%%%%%%%%%%%%%%%%%%%% End of Mutation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % for saving R values of son
schineder_R2_daughter=0; % for saving R values of daughter

%%%%%%%%%%%% Finding R of SON Topology %%%%%%%%%%
        c=mutat_adj_son;    %sconverting 3D matrix into 2D matric for calculation of R    
  
            for k=1:N
                degree_R(k)=sum(c(:,k));    %%degree calculation of matrix C, ready for calculation of schineder R
            end

    %%%%%%%%%%%%%%%%%%%% Calculating R   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Calculating Maximum Degree Node %%%%%%%%%%%%%%%%
    [max_num,max_idx] = max(degree_R(:));
    max_idx;
    %%%%%%%%%%%% Deleting Maximum Degree Node %%%%%%%%%%%%%%%%%%
    A_D=c;
    A_D(:,max_idx)=0;
    A_D(max_idx,:)=0;
    %%%%%%%%% Finding 2nd Maximum degree %%%%%%%%%%%%%%%%%%%%%%%
    second_Degree(1,N)=0;
    for i=1:N
        for j=1:N
            second_Degree(j)= sum(A_D(:,j));
        end
    end
    [second_max_num,second_max_idx] = max(second_Degree(:));
    second_max_idx;
    %%%%%%%%%%%%%% Finding 90% Degrees in Comparison to Maximum degree %%%%%
    ninty_percent_max_degree=(max_num/100)*90;
    ninty_percent_threshold=0;
    num_ninty_percent_nodes=0;
   for j=1:N
        if second_Degree(j)>= ninty_percent_max_degree;
           num_ninty_percent_nodes= num_ninty_percent_nodes+1;
        end
   end
    num_ninty_percent_nodes;
    %%%%%%% Calculating Fittness Function R %%%%%%%
    fitness_func_R= num_ninty_percent_nodes/N;
     schineder_R1_son=fitness_func_R;
     schineder_R1_son;
%%%%% End of calculating R for SON Topology %%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Start of Mutation Daughter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mutat_adj_daughter(N,N)=0;
mutat_adj_daughter=M_Topology_new;
% converting 3D Matrix into 2D Matrix
 for i=1:pop_members
    for j=1:N
        for k=1:N
            x=pop1_adj(j,k,i);
            mutat_adj_daughter(j,k)=x; 
        end
    end
 end
%%%%%%% Calculate Degree of complete matix under mutation %%%%%%%%
for k=1:N
  mutat_degree(k)=sum(mutat_adj_daughter(:,k));    
end
%%%% calculating first maximum degree node for mutation
[max_num,max_idx] = max(mutat_degree(:));
node1_index= max_idx;
node1_degree= max_num;

%%%% calculating second maximum degree node for mutation
mutat_degree_second=mutat_degree;
mutat_degree_second(max_idx)=0;
[max_num,max_idx] = max(mutat_degree_second(:));
Member_check=0;
for i=1:N
    
    if Member_check<mutat_degree_second(i)
        if mutat_adj_daughter(node1_index,i)==0
            if mutat_adj_daughter(i,node1_index)==0
        node2_index=i; 
        node2_degree=mutat_degree_second(i);
            end
        end
    end
end
node2_index;
node2_degree;
 
%%%%% Calculating partner of node 1 %%%%%
degree_member_check=0;
node1_neighbour_degree=0;
node1_neighbour_index=0;
for i=1:N

    Member_check =mutat_adj_daughter(i,node1_index);

    if Member_check == 1 && i~=node2_index && i~=node1_index%checking edges of node 1
       if mutat_adj_daughter(i,node2_index)==0
           
                degree_member_check=sum(mutat_adj_daughter(:,i)); %if edge exists with any node then calculate degree of that node
                if node1_neighbour_degree<degree_member_check
                    node1_neighbour_degree= degree_member_check ;
                    node1_neighbour_index=i;
                end
           
        end
    end
end
node1_neighbour_index;
node1_neighbour_degree;


%%%% Calculating partner of node 2 %%%%%
degree_member_check=0;
node2_neighbour_degree=0;
node2_neighbour_index=0;
for i=1:N

    Member_check =mutat_adj_daughter(i,node2_index);
%    Member_check = ismember(i, node2_index); %%check all rows of node2_index
    if Member_check == 1  
        if mutat_adj_daughter(i,node1_index)==0 
            if mutat_adj_daughter(i,node1_neighbour_index)==0 %checking edges of node 1
                degree_member_check=sum(mutat_adj_daughter(:,i)); %if edge exists with any node then calculate degree of that node
                    if node2_neighbour_degree<degree_member_check
                        node2_neighbour_degree= degree_member_check ;
                        node2_neighbour_index=i;
                    end
            end
        end
    end
end
node2_neighbour_index;
node2_neighbour_degree;

%% Sorting Degrees of Node 1, Node 2, Node 1 neighbour, Node 2 neighbour %%

sort_array = zeros(1,4);       
sort_array(1)=node1_degree;
sort_array(2)=node2_degree;
sort_array(3)=node1_neighbour_degree;
sort_array(4)=node2_neighbour_degree;
sorting=sort(sort_array);
di=node1_degree;
dj=node2_degree;
dk=node1_neighbour_degree;
dl=node2_neighbour_degree;
d1=sorting(4);
d2=sorting(3);
d3=sorting(2);
d4=sorting(1);

d1;d2;d3;d4;

%%%%%%%%%%%%%%%%%%%%%%% End of Sorting Degrees %%%%%%%%%%%%%%%%%%%%%
        
s1=(d1-d2)+(d3-d4); s2=abs((di-dj)+(dk-dl)); p=s1/s2;

if p<threshold
node1_index;
node1_degree;
node2_index;
node2_degree;
node1_neighbour_index;
node1_neighbour_degree; 
node2_neighbour_index;
node2_neighbour_degree;

mutat_degree;
mutat_adj_daughter(node1_index,node2_index)=1; %%making edge between node i and node k
mutat_adj_daughter(node2_index,node1_index)=1; %%making edge between node k and node i
mutat_adj_daughter(node1_neighbour_index,node2_neighbour_index)=1; %%making edge between node j and node l
mutat_adj_daughter(node2_neighbour_index,node1_neighbour_index)=1; %%making edge between node l and node j
for k=1:N
  mutat_degree_2(k)=sum(mutat_adj_daughter(:,k));    %%degree calculation after formation of new edges by mutation between i and k,  j and l
end

%%%%% Equalization  of Degree After Mutation %%%%%%%%%%
mutat_degree_3=mutat_degree_2;  
for i=1:N
    
    if i~=node2_index
        if mutat_degree_3(node1_index)>mutat_degree(node1_index)
            if mutat_adj_daughter(i,node1_index)==1 %checking edges of node 
                mutat_adj_daughter(i,node1_index)==0;
                x=mutat_degree_3(node1_index)-1;
                mutat_degree_3(node1_index)=x;
            end
        end
    end
    if i~=node1_index
        if mutat_degree_3(node2_index)>mutat_degree(node2_index)
            if mutat_adj_daughter(i,node2_index)==1 %checking edges of node 
                mutat_adj_daughter(i,node2_index)==0;
                x=mutat_degree_3(node2_index)-1;
                mutat_degree_3(node2_index)=x;
            end
        end
    end
    if i~=node2_neighbour_index
        if mutat_degree_3(node1_neighbour_index)>mutat_degree(node1_neighbour_index)
            if mutat_adj_daughter(i,node1_neighbour_index)==1 %checking edges of node 
                mutat_adj_daughter(i,node1_neighbour_index)==0;
                x=mutat_degree_3(node1_neighbour_index)-1;
                mutat_degree_3(node1_neighbour_index)=x;
            end
        end
    end   
    if i~=node1_neighbour_index
        if mutat_degree_3(node2_neighbour_index)>mutat_degree(node2_neighbour_index)
            if mutat_adj_daughter(i,node2_neighbour_index)==1 %checking edges of node 1
                mutat_adj_daughter(i,node2_neighbour_index)==0;
                x=mutat_degree_3(node2_neighbour_index)-1;
                mutat_degree_3(node2_neighbour_index)=x;
            end
        end
    end   
end
mutat_adj_daughter;
%%%% End of Degree Equalization %%%%%%%   

%%%% Re Degree Calculation after equaliztion of degree %%%%%%
for k=1:N
  mutat_degree_4(k)=sum(mutat_adj_daughter(:,k));    %%degree calculation after deletion of extra edges
end

end  %%% End of p< threshold condtion
%%%%%%%%%%%%%%%%%%%%%%%%% End of Mutation Daughter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Finding R of Daughter Topology %%%%%%%%%%
        c=mutat_adj_daughter;    %sconverting 3D matrix into 2D matric for calculation of R    
  
            for k=1:N
                degree_R(k)=sum(c(:,k));    %%degree calculation of matrix C, ready for calculation of schineder R
            end

    %%%%%%%%%%%%%%%%%%%% Calculating R   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Calculating Maximum Degree Node %%%%%%%%%%%%%%%%
    [max_num,max_idx] = max(degree_R(:));
    max_idx;
    %%%%%%%%%%%% Deleting Maximum Degree Node %%%%%%%%%%%%%%%%%%
    A_D=c;
    A_D(:,max_idx)=0;
    A_D(max_idx,:)=0;
    %%%%%%%%% Finding 2nd Maximum degree %%%%%%%%%%%%%%%%%%%%%%%
    second_Degree(1,N)=0;
    for i=1:N
        for j=1:N
            second_Degree(j)= sum(A_D(:,j));
        end
    end
    [second_max_num,second_max_idx] = max(second_Degree(:));
    second_max_idx;
    %%%%%%%%%%%%%% Finding 90% Degrees in Comparison to Maximum degree %%%%%
    ninty_percent_max_degree=(max_num/100)*90;
    ninty_percent_threshold=0;
    num_ninty_percent_nodes=0;
   for j=1:N
        if second_Degree(j)>= ninty_percent_max_degree;
           num_ninty_percent_nodes= num_ninty_percent_nodes+1;
        end
   end
    num_ninty_percent_nodes;
    %%%%%%% Calculating Fittness Function R %%%%%%%
    fitness_func_R= num_ninty_percent_nodes/N;
     schineder_R2_daughter=fitness_func_R;
     schineder_R2_daughter;
%%%%% End of calculating R for Daughter Topology %%%%%%%%
Father_R;
Mother_R;
schineder_R1_son;
schineder_R2_daughter;



%%%%%%% Replacing best topology with father from father and son %%%%%%%%
if schineder_R1_son>Father_R
pop1_adj(:,:,F_index)=F_Topology_new;    
end
%%%%%% Replacing Best topology with mother from mother and daughter %%%%%%
if schineder_R2_daughter>Mother_R 
pop2_adj(:,:,M_index)=M_Topology_new;   
end
schineder_R_imax(o)=Father_R;
o;
end % End of imax itrations loop

plot_test=plot_test+schineder_R_imax;
xx
end
plot_test=plot_test/avg;

toc;
%%%%%%%%%%%%%%%%%%%%%%% End of Enhanced GA %%%%%%%%%%%%%%%
figure;
plot(plot_test, 'r','LineWidth',2.00);
legend('GA-AREA');
ylabel('R','fontsize',20)
xlabel('Number of Iterations','fontsize',20)
%plot(o,schineder_R_imax, 'r', 'LineWidth',2.0)
