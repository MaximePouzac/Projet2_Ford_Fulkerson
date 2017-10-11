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
%   - SEC:  Vecteur des successeurs de chaque sommet
%   - FlMax:Vecteur de flot maximal possible sur chaque arc
%   
%
%% Initialisations
NSUC = uint16([3 0 2 1]);
n = size(NSUC,2);
X = uint16(1:n);
m = sum(NSUC);
%
% Vecteur des successeurs de chaque sommet
SUC = uint16([2 3 4 2 4 2]);
%
% Vecteur des flots maximaux de chaque arc
FlMax = [inf 1 4 5 2 3];
%
% Vecteur de flot courant phi
phi = zeros(1,m);
%
MARQUE = false(1,n); % MARQUE est un vecteur logique
MARQUE(2) = true; % on marque le sommet a == 2 ( b == 1 (b,a) == 1)
%
NONMARQUES = X(~MARQUE); % NONMARQUES contient la liste des sommets non marqués
%
%% Algorithme de FF
while ismember(1,NONMARQUES) % Tant que b == 1 non marqué, et donc que le flot n'est pas maximal
    CANDIDATS = false(1,n); % CANDIDATS est un vecteur logique contenant les candidats à
    % être marqués
    %
    %% 1.   MAJ flot courant phi
    beta = inf;
    vcocycle = zeros(1,m); % vecteur cocycle des sommets non marqués
    for l=1:size(NONMARQUES,2)
        i = NONMARQUES(l); % i est non marqué
        if NSUC(i) ~= 0 % le nombre de successeurs de i est non nul
            prsuc = sum(NSUC(1:i-1)) + 1; % prsuc contient l'indice du 1er successeur de i dans SUC
            for k = prsuc:prsuc+NSUC(i)-1
                j = SUC(k); % (i,j) est un arc
                if MARQUE(j)
                    % j est un sommet marqué (et i est nonmarqué donc (i,j)
                    % appartient au cocycle
                    % donc i est candidat à être marqué
                    CANDIDATS(i) = true;
                    beta = min(beta,FlMax(k)-phi(k)); % beta > 0
                    vcocycle(k) = 1;
                end
            end
        end
    end
    phi = phi + beta*vcocycle; %MAJ phi
    %
    %% 2.   Marquer sommets
    liste_candidats_marquage = X(CANDIDATS);
    for l=1:size(liste_candidats_marquage,2)
        i = liste_candidats_marquage(l); % i est non marqué et candidat à être marqué
        if NSUC(i) ~= 0
            % le nombre de successeurs de i est non nul
            prsuc = sum(NSUC(1:i-1)) + 1; % prsuc contient l'indice du 1er successeur de i dans SUC
            for k = prsuc:prsuc+NSUC(i)-1
                j = SUC(k); % j est successeur du sommet i candidat au marquage
                if MARQUE(j) && phi(k) == FlMax(k)
                    % i est non marqué , j est marqué, (i,j) est un arc (de numéro k) , et la
                    % valeur de la tension sur cet arc est égale à la longueur
                    % de l'arc (i,j)
                    % donc on marque i
                    MARQUE(i) = true; % on marque le sommet i
                    NONMARQUES = setdiff(NONMARQUES,i); % on enlève i des sommets non marqués
                end
            end
        end
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
