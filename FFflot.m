%% Algorithme de *Ford-Fulkerson* pour les flot
%
% Application à la recherche du flot maximal dans un graphe (X,U)
%
% Représentation du graphe
%   - n == nombre de sommets
%   - m == nombre d'arcs
%
%   - X:    Liste des sommets de G
%   - NSUC: Vecteur du nombre de successeurs de chaque sommet
%   - SUC:  Vecteur des successeurs de chaque sommet
%   - NPRED:Vecteur du nombre de prédécesseurs de chaque sommet
%   - PRED: Vecteur des prédécesseurs de chaque sommet
%   - FlMax:Vecteur de flot maximal possible sur chaque arc
%   
%
%% Initialisations
NSUC = uint16([1 2 2 1]);
NPRED = uint16([2 1 1 2]);
n = size(NSUC,2);
X = uint16(1:n);
m = sum(NSUC);
%
% Vecteur des successeurs de chaque sommet
SUC = uint16([2 3 4 1 4 1]);
%
% Vecteur des predecesseurs de chaque sommet
PRED = uint16([3 4 1 2 2 4]);
%
% Vecteur des flots maximaux de chaque arc (en regardant les sucesseurs)
FlMaxSUC = [inf 1 4 5 2 3];
% Vecteur des flots maximaux de chaque arc (en regardant les sucesseurs)
FlMaxPRED = [5 3 inf 1 4 2];
%
% Vecteur de flot courant phi
phi = zeros(1,m);
%
% MARQUE est une matrice indiquant si les sommets sont marqués ou non
% Le marquage indique si une amélioration du flux est possible
%   -> MARQUE(1, i) indique si le sommet i est marqué
%   -> MARQUE(2, i) indique quel est le sommet qui a permis de marquer i
MARQUE = zeros(2,n);
MARQUE(:,2) = [ +1; 1 ]; % on marque le sommet a == 2 ( b == 1 (b,a) == 1)
%
%% Algorithme de FF
while MARQUE(1,1) == 0 % Tant que b == 1 non marqué, et donc que le flot n'est pas maximal
    %% 1. Trouver un chemin qui permet d'améliorer le flux
    marquage_en_cours = true;
    while marquage_en_cours % Tant que l'on marque des sommets
        marquage_en_cours = false;
        
        % Pour chaque sommet marqué u non encore traité
        for u=find(MARQUE(1,:)~=0)
            prsuc = sum(NSUC(1:u-1)) + 1; % prsuc contient l'indice du 1er successeur de u dans SUC
            for indV = prsuc:prsuc+NSUC(u)-1 % Pour chaque arc (u,v)
                v = SUC(indV);
                if MARQUE(1,v)==0 && phi(indV) < FlMaxSUC(indV) % Si v n'est pas marqué et (u,v) non saturé, alors marquer le sommet
                    MARQUE(:,v) = [ +1; u ];
                    marquage_en_cours = true;
                end
            end
            
            prpred = sum(NPRED(1:u-1)) + 1; % prpred contient l'indice du 1er prédécesseur de u dans PRED
            for indV = prpred:prpred+NPRED(u)-1 % Pour chaque arc (v,u)
                v = PRED(indV);
                if MARQUE(1,v)==0 && 0 < phi(indV) && FlMaxPRED(indV) < inf % Si v n'est pas marqué et (u,v) a un flot non nul (donc (v,u) non saturé), alors marquer le sommet
                    MARQUE(:,v) = [ -1; u ];
                    marquage_en_cours = true;
                end
            end
        end
    end
    
    %% 2. Mise à jour du flot courant phi si non maximal
    if MARQUE(1,1) == 0 % Si le puits n'est pas marqué, le flot est maximal
        break;
    else
        % Trouver le chemin marqué
        chemin = ComputeWay(MARQUE, SUC, NSUC);
        
        % Augmenter le flot
        alpha = inf;
        taille_chemin = size(chemin,2);
        % -> Chercher la valeur de mise à jour du flot
        for i=1:taille_chemin % Pour chacun des arcs du chemin
            indArc = chemin(2,i);
            if chemin(1,i) > 0 % Si l'arc est parcouru dans le sens direct
                alpha = min(alpha, FlMaxSUC(indArc) - phi(indArc));
            else % Si l'arc est parcouru dans le sens indirect
                alpha = min(alpha, phi(indArc));
            end
        end
        % -> Mettre à jour le flot
        for i=1:taille_chemin
            indArc = chemin(2,i);
            phi(indArc) = phi(indArc) + alpha * chemin(1,i);
        end
        
        % -> Ne plus marquer aucun sommet à part le sommet de départ
        MARQUE = zeros(2,n);
        MARQUE(:,2) = [ +1; 1 ];
    end
end
%% 3. Post-traitement : affichage du flot
%
% Pour chaque sommet, afficher pour chacun de ces successeurs le flot de
% l'arc les reliant
for sommet=1:n
    if NSUC(sommet) ~= 0
        % premSuc contient l'indice du 1er successeur de sommet dans SUC
        premSuc = sum(NSUC(1:sommet-1)) + 1;
        % indSuc contient l'indice du successeur courant de sommet dans SUC
        for indSuc = premSuc:premSuc+NSUC(sommet)-1
            disp(['(' num2str(sommet) ', ' num2str(SUC(indSuc)) ') = ' ...
                  num2str(phi(indSuc))]);
        end
    end
end
