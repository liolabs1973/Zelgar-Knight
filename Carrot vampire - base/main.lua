------------------------------------------------------------------
-- Stage Codeur Commando - Maison des jeunes de Dour            --
-- Game : "Carrot Vampire" créé avec Love2D  par Liolabs        --
-- Version 1.0                                                  --
------------------------------------------------------------------
-- Objectif :                                                   --
-- **************                                               --
-- Apprentissage des notions de base du langage LUA avec        --
-- le moteur de jeu : Love2D                                    --
------------------------------------------------------------------


------------------------------------------------------------------
-- checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)  --> Ver 1.0         --
------------------------------------------------------------------
-- Paramètres :                                                 --
-- ****************                                             --
-- x1,y1  : Position du coin supérieur gauche de l'objet 1      --
-- w1     : largeur de l'objet 1                                --
-- h1     : heuteur de l'objet 1                                --    
-- x2,y2 : Position du coin supérieur gauche de l'objet 2       --
-- w2     : largeur de l'objet 2                                --
-- h2     : heuteur de l'objet 2                                --
-- Son rôle :                                                   --
-- **************                                               --
-- la fonction compare la position de l'objet 1 et l'objet 2    --
-- si leurs positions respectives se croisent, la fonction      --
-- retourne la valeur "1" ou vrai                               --
-- Cela signifie que les objets sont alors en collision.        --
------------------------------------------------------------------
function checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)
   return x1 < x2 + w2 and
          x2 < x1 + w1 and
          y1 < y2 + h2 and
          y2 < y1 + h1
end

------------------------------------------------------------------
-- Fonction love.load() --> Version validée par Love2D          --
------------------------------------------------------------------
-- Son rôle :                                                   --
-- **************                                               --
-- La fonction initialise les données nécessaires pour le       --
-- démarrage du jeu, il charge, les images, les sons, les       --
-- musiques et les variables nécessaires au bon fonctionnement  --
-- du jeu.                                                      --
------------------------------------------------------------------
function love.load()
   background = love.graphics.newImage("assets/background.png")
   character = love.graphics.newImage("assets/character.png")
   enemy = love.graphics.newImage("assets/enemy.png")
   bonus = love.graphics.newImage("assets/bonus.png")
   characterX = 100
   characterY = 100
   enemyX = 500
   enemyY = 300
   bonusX = 200
   bonusY = 400
   bonusCollected = false
   music = love.audio.newSource("assets/music.mp3", "stream")
   music:setLooping(true)
   music:play()
   collectSound = love.audio.newSource("assets/collect.mp3", "static")
   hitSound = love.audio.newSource("assets/hit.mp3", "static")
   score = 0
   scoreFont = love.graphics.newFont(24)
   gameOverFont = love.graphics.newFont(36)
   gameOver = false
end

------------------------------------------------------------------
-- Fonction love.update(dt) --> Version validée par Love2D      --
------------------------------------------------------------------
-- Paramètres :                                                 --
-- ****************                                             --
-- dt : delta time, ce paramètre assure une execution du jeu    --
-- avec un meme niveau de performance que l'on soit sur une     --
-- machine puissante de dernière génération ou bien sur une     --
-- un peu moins performante.                                    -- 
-- Son rôle :                                                   --
-- **************                                               --
-- mettre à jour tous les elements qui interragissent durant    --
-- le jeu. la position des objets, les musiques, les sons à     --
-- jouer, les évèments du jeu, etc....                          --
------------------------------------------------------------------
function love.update(dt)
   ---------------------------------------
   -- Gestion du déplacement du joueur  --
   ---------------------------------------
   -- Si la touche fleche de droite est enfoncée alors
   if love.keyboard.isDown("right") then
      -- on déplace le joueur vers la droite
      characterX = characterX + 100 * dt
   -- Sinon si la touche fleche de gauche est enfoncée alors
   elseif love.keyboard.isDown("left") then
      -- on déplace le joueur vers la gauche
      characterX = characterX - 100 * dt
   end
   -- la touche fleche vers le bas est enfoncée alors
   if love.keyboard.isDown("down") then
      -- on fait descendre le joueur vers le bas de l'écran
      characterY = characterY + 100 * dt
   -- sinon si la touche fleche vers le haut est enfoncée alors
 elseif love.keyboard.isDown("up") then
      -- on fait remonter le joueur vers le haut de l'écran
      characterY = characterY - 100 * dt
   end

   ----------------------------------------
   -- Gestion du déplacement de l'ennemi --
   ----------------------------------------
   -- si l'ennemi est à droite du joueur
   if enemyX > characterX then
      -- on déplace l'ennemi vers la gauche
      enemyX = enemyX - 50 * dt
   -- sinon si l'ennemi est à gauche du joueur
   elseif enemyX < characterX then
      -- on déplace l'ennemi vers la droite
      enemyX = enemyX + 50 * dt
   end
   -- si l'ennemi est plus bas que le joueur
   if enemyY > characterY then
      -- on déplace l'ennemi vers le haut
      enemyY = enemyY - 50 * dt
   -- sinon si l'ennemi est plus haut que le joueur
   elseif enemyY < characterY then
      -- on déplace l'ennemi vers le bas
      enemyY = enemyY + 50 * dt
   end

  --------------------------------------------------------------------
  -- On vérifie si il y a une collision entre le joueur et l'ennemi --
  --------------------------------------------------------------------
   -- Si il y a collision entre le joueur et l'ennemi alors
   if checkCollision(characterX, characterY, character:getWidth(), character:getHeight(), 
                     enemyX, enemyY, enemy:getWidth(), enemy:getHeight()) then
      -- On stoppe la musique, on joue le touche de collision avec 
      -- l'ennemi et on active la variable gameOver
      music:stop()
      hitSound:play()
      gameOver = true
   end

  --------------------------------------------------------------------
  -- On vérifie si il y a une collision entre le joueur et l'ennemi --
  --------------------------------------------------------------------
   -- Si il y a collision entre le joueur et l'objet bonus alors
   if checkCollision(characterX, characterY, character:getWidth(), character:getHeight(), 
                     bonusX, bonusY, bonus:getWidth(), bonus:getHeight()) then
      -- On stoppe la musique, on joue le touche de collision avec 
      -- l'objet bonus et on active la variable bonusCollected et on incrémente le score
      music:stop()
      collectSound:play()
      bonusCollected = true
      score = score + 1
   end
  ------------------------------------- 
  -- Gestion de l'evenement gameOver --
  -------------------------------------
   -- si le jeu est gameOver et que la touche "r" est enfoncée alors
   if gameOver and love.keyboard.isDown("r") then
      -- On réinitialise le jeux      
      love.load()
   end
end

------------------------------------------------------------------
-- Fonction love.draw() --> Version validée par Love2D          --
------------------------------------------------------------------
-- Paramètres :                                                 --
-- ****************                                             --
-- dt : delta time, ce paramètre assure une execution du jeu    --
-- avec un meme niveau de performance que l'on soit sur une     --
-- machine puissante de dernière génération ou bien sur une     --
-- un peu moins performante.                                    -- 
-- Son rôle :                                                   --
-- **************                                               --
-- La fonction dessine à l'écran tous les éléments              --
-- qui correspondent à l'état actuel du jeu                     --
------------------------------------------------------------------
function love.draw(dt)
  
  -- On dessine le fond d'écran
  love.graphics.draw(background, 0, 0)
  
  -- Si l'objet bonus est toujours disponible alors  
  if not bonusCollected then
    -- on dessine l'ennemi
    love.graphics.draw(enemy, enemyX, enemyY)
    -- on dessine l'objet bonus
    love.graphics.draw(bonus, bonusX, bonusY)
    -- on dessine le joueur 
    love.graphics.draw(character, characterX, characterY)
  -- sinon on lance l'écran de victoire
  else
      -- on choisi la couleur noire
      love.graphics.setColor(0, 0, 0)
      -- on dessinne un rectangle de la taille de l'écran
      love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth() , love.graphics:getHeight())
      -- on choisi la couleur verte
      love.graphics.setColor(0, 1, 0)
      -- on affiche le texte "You win!" de manière centrée
      love.graphics.print("You win!", love.graphics:getWidth()/2-40, love.graphics:getHeight()/2-10)
      -- on choisi la couleur blanche
      love.graphics.setColor(1, 1, 1)
  end
  
  -- On affiche le score du jeu
  love.graphics.setFont(scoreFont)
  love.graphics.print("Score: " .. score, 10, 400)
  
  -- Si le jeu est en gameOver
  if gameOver then
      -- on choisi la couleur noire
      love.graphics.setColor(0, 0, 0)
      -- on dessinne un rectangle de la taille de l'écran
      love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth() , love.graphics:getHeight())
      -- on choisi la couleur rouge
      love.graphics.setColor(1, 0, 0)
      -- on affiche le texte "Game Over
      love.graphics.setFont(gameOverFont)
      love.graphics.print("Game Over", 250, 200)
      -- On affiche le texte "Press R to restart
      love.graphics.print("Press R to restart", 200, 250)
  end
end
