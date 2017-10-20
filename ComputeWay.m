%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fonction qui retourne le chemin suivi en arc a partir des sommets marqués

function Way = ComputeWay(MARQUES,SUC,NSUC)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Paramètres
%   - MARQUES : Matrice des sommets marqués avec sens de marquage
%   - NSUC: Vecteur du nombre de successeurs de chaque sommet
%   - SUC:  Vecteur des successeurs de chaque sommet
%%Type retour : WAY : Matrice de taille 2*(size(MARQUES(1,:) != 0)-1)
%indiquant les arcs suivis et les sens ( WAY(1,:)= Sens, WAY(2,:)= Arc
%Le sommet 2 est toujours sommet de départ, et 1 sommet d'arrivé
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calcul du chemin suivi par sommet
%Récupération du point d'arrivé
tmpWay = [  MARQUES(1,1) 1;
            1 2];


indice = MARQUES(2,2); %sommet qui marque le sommet de départ

while indice ~= 2
    tmp = [MARQUES(1,indice);MARQUES(2,indice)]; %Nouvelle colonne de tmpWay
    tmpWay = [ tmp , tmpWay]; 
    indice = MARQUES(2,indice); %Mise a jour de l'indice par le sommet marquant l'ancien indice
end

%Calcul du chemin suivi par arc
taille = size(tmpWay,2);    % Nombre de sommet dans le chemin
Way = zeros(2,taille-1);    % Le chemin à parcourir (arcs)

for i = 1:taille-1 % Parcourir les sommets 2 à 2 pour trouver les arcs
        s1 = tmpWay(2,i);
        s2 = tmpWay(2,i+1);
        
    if (tmpWay(1,i+1) == 1)        
        prsuc = sum(NSUC(1:s1-1)) + 1;
        SucS1 = SUC(prsuc:prsuc+NSUC(s1)-1);
        numArc = prsuc + find(SucS1 == s2) - 1;
        tmp = [tmpWay(1,i+1);numArc];
        Way(:,i) = tmp;
        
    elseif (tmpWay(1,i+1) == -1)
        prsuc = sum(NSUC(1:s2-1))+1;
        SucS2 = SUC(prsuc:prsuc+NSUC(s2)-1);
        numArc = prsuc + find(SucS2 == s1) - 1;
        tmp = [tmpWay(1,i+1);numArc];
        Way(:,i) = tmp;
        
    end
end
    
 
        
        
            
     
