function [] = raz_probs()

%prob313()
prob314()
end

function [dec] = cliqueToDec(clique)

%binarray = zeros(10,1);
dec = 0;
for i=1:10
    if (ismember(i, clique))
        %binarray(i) = 1
        dec = dec + 2^(10-i);
    end
end

end

%% prob 2.6
function [] = prob26()
load('WikiAdjSmall.mat');

dist = graphallshortestpaths(A,'Directed',false);

hist = zeros(1000,1);

[width, height] = size(A);

for i=1:width
    for j=1:i
        if (dist(i,j) ~= inf && dist(i,j) ~= 0)
            hist(dist(i,j)) = hist(dist(i,j)) + 1;
        end
    end
end

hist(1:20)

end

%% prob 2.7

function [] = prob27()
C = load('cliques.mat');

C = C.cl;
len = length(C);

maxCliques = cell(100,1);
count = 1
for c1=1:len
    isContained = 0;
    for c2=1:len
        if(c1 ~= c2 && all(ismember(C{c1}, C{c2})))
            isContained = isContained + 1;
            break
        end
    end
    if(isContained == 0)
       maxCliques{count} = C{c1};
       count = count + 1;
    end
end

count = count - 1;

celldisp(maxCliques(1:count))

decCliques = zeros(count,1);
for i=1:count-1
    decCliques(i) = cliqueToDec(maxCliques{i});
end
    
decCliques

end

%% prob 3.13

function [] = prob313(a,b)
load('ABmatrices.mat');
findImmoralities(a,b);

findImmoralities(b,a);
end

function [] = findImmoralities(a,b)


undirA = a;
undirB = b;

[width, height] = size(a);

%graphsAreIsomorphic = graphisomorphism(sparse(a), sparse(b), 'Directed', false)

% build undirected graph
for i=1:width
    for j=1:height
        if (a(i,j) == 1)
            undirA(j,i) = 1;
        end
        if (b(i,j) == 1)
            undirB(j,i) = 1;
        end        
    end
end


% degrees of nodes are the same
sum(undirA)
sum(undirB)


% adjacency matrices of undirected graphs are the same
for i=1:width
    for j=1:height
        if (undirA(i,j) ~= undirB(i,j))
            i
            j
        end
    end
end
a
b
markovEq = 1;

% refactor code below so that all immoralities are obtained in two separate
% sets for each graph and then are
for j=1:height
    %j
    parentsA = find(a(:,j)); % parents of node j in graph A
    parentsB = find(b(:,j));
    for k=1:length(parentsA)
        for l=k+1:length(parentsA)
            if (undirA(parentsA(k), parentsA(l)) == 0)
                % check if other graph has immorality
                parentsExist = ismember(parentsA(k), parentsB) && ismember(parentsA(l), parentsB);
            
                immorality = [j, parentsA(k), parentsA(l)]
                
                if (parentsExist && undirB(parentsA(k), parentsA(l)) == 1)
                    markovEq = 0;
                    badImmorality = [k, l]
                end    
            end
        end
    end
end

markovEq
end


function [] = prob314()

%c122, c232, c121323, c232113 = 1,2,3,4

%indexC12 = PotArray(c121323, [0 0 0 0 1 1 1 1])
initProb = [0.9 0.1];
pC12 = initProb;
pC13 = initProb;
pC23 = initProb;
pC32 = initProb;
pC31 = initProb;
pC21 = initProb;

pC121332 = [0.9^3 0.9^2*0.1 0.9^2*0.1 0.9*0.1^2 0.9^2*0.1 0.9*0.1^2 0.9*0.1^2 0.1^3];

% conditional prob tables: p(C12(2) = 1 | C12 C13 C23) and the other one
pC122gC121332 = [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1];
pC232gC232113 = [1 1 1 0 0 0 0 0; 0 0 0 1 1 1 1 1];

% child node states
pC122 = [0 1];
pC232 = [1 0];

% lambda messages
lamC122 = pC122 * pC122gC121332
lamC232 = pC232 * pC232gC232113;

% calculate the lambda evidence at the parent node
p1C121332 = lamC122 .* pC121332

% normalise the probability of the joint state
p1C121332 = p1C121332 ./ sum(p1C121332)

indicesC13 = [1,2,5,6; 3,4,7,8];
indicesC32 = [1,3,5,7; 2,4,6,8];

% calculate the marginals p(C12) p(C13) p(C23)
pC12 = [sum(p1C121332(1:4)) sum(p1C121332(5:8))]
pC13 = [sum(p1C121332(indicesC13(1,:))) sum(p1C121332(indicesC13(2,:)))]
pC32 = [sum(p1C121332(indicesC32(1,:))) sum(p1C121332(indicesC32(2,:)))]

pC232113 = [pC23(1)*pC21(1)*pC13(1) pC23(1)*pC21(1)*pC13(2) pC23(1)*pC21(2)*pC13(1) pC23(1)*pC21(2)*pC13(2) pC23(2)*pC21(1)*pC13(1) pC23(2)*pC21(1)*pC13(2) pC23(2)*pC21(2)*pC13(1) pC23(2)*pC21(2)*pC13(2)]

% calculate the lambda evidence at the parent node        
p1C232113 = lamC232 .* pC232113;        

% normalise the probability of the joint state
p1C232113 = p1C232113 ./ sum(p1C232113)
     
% calculate the marginals p(C23) p(C21) p(C13)
pC23 = [sum(p1C232113(1:4)) sum(p1C232113(5:8))]
pC21 = [sum(p1C232113(indicesC13(1,:))) sum(p1C232113(indicesC13(2,:)))]
pC13 = [sum(p1C232113(indicesC32(1,:))) sum(p1C232113(indicesC32(2,:)))]

display('--------------------')

pC12
pC13
pC23
pC32
pC31
pC21

        
end