# Handoff — Quando as Raízes Despedaçam (QRD)

Estado do projeto em 28/10/2026. Jogo de plataforma 2D em GameMaker (IDE 2024.14.4, runtime 2024.14.4.268), GML.

## Fluxo do jogo

`rMenu` → ENTER → `rTuneis` → saída → painel "Fim da fase." com o gancho da Mariana → ENTER → `rMonologo` (monólogo da Luma, tela preta com texto sendo digitado; ENTER completa/avança, ESC pula; texto em `oMonologo` Create, rascunho) → `rChefe` (luta com o chefe) → painel de vitória → volta ao menu.

- **F3 no menu** vai direto para `rChefe` (atalho de teste).
- A ligação túneis → chefe está só no `oExit` (`qrd_show_info(..., false, rMonologo)`, e o `oMonologo` vai para a `rChefe`); o arquivo da `rTuneis` não muda.
- Ao entrar na `rChefe` a Luma começa no início da sala (o checkpoint dos túneis não vale lá).

- **Menu:** cena de corrida em `oMenu` (sem objetos extras): parallax dos túneis em 2×, pista com os tiles 19/27/35 de `sTunTiles`, Luma correndo no lugar, robôs (`sEnemyR`/`sEnemyD`) vindo da direita. Espaço/W/↑ pula (pulo duplo), Z/J/clique atira (`sBullet`/`sBulletHit`), ENTER começa, ESC fecha. Sem tecla por 5 s a Luma pula sozinha. Zera checkpoints e registros (`qrd_reset_run`). A arte antiga `sMenuBg` saiu (backup em `_backup_menu_ia`).
- **Na fase:** ESC volta ao menu, R reinicia no último checkpoint.
- As salas `rOne`, `rTwo`, `rThree` e `rFour` foram apagadas (backup abaixo).

## Controles em `rTuneis` e `rChefe`

A/D ou setas: andar · Espaço/X/K: pular (de novo no ar = pulo duplo) · Z/J/clique: atirar · W ou S + tiro: mirar para cima/baixo · S + Espaço: descer de plataforma · no ar, S + tiro: planar. Controle (gamepad) também funciona.

## Onde está cada coisa

| Sistema | Arquivos |
|---|---|
| Física por sala (velocidade, pulo, mira, câmera) | `scripts/scrQRD` → `qrd_profile(room)`. `rTuneis` e `rChefe` usam o perfil "referência" (aceleração, coyote, rampas, mira por teclas, câmera `follow`). |
| Jogadora (movimento, dano, morte, HUD) | `objects/oPlayer` (Step, Draw em meia escala, Draw GUI = HUD) |
| Colisão da jogadora | Sprite `sPlayerMask` (12×36, origem 26,24, simétrica). **Não depende da arte.** |
| Arma (cetro) e tiro | `objects/oGun` (End Step), `objects/oBullet` (Draw em meia escala, máscara 18×18 cheia) |
| Inimigos | `oEnemy` (anda, vira em beirada), `oEnemyGuard` (persegue ao ver a Luma) |
| Perigos dos túneis | `oTunSaw*`, `oTunBlock` (bloco quebrável a tiro) |
| Terreno | `oWall` (sólido), `oPlat` (plataforma de mão única), `oSlopeL/R` (rampas) |
| Registros (5 coletáveis informativos) | `oCollectible` + textos em `scrQRD` (`global.info`), painel `oInfo` (pausa o jogo) |
| Checkpoints | `oCheckpoint` (ativa também ao passar por cima no pulo) |
| Saída dos túneis | `oExit` → painel com `global.ending` (`scrQRD`) → `rChefe`. Porta = `sTunDoor` (32×64, recortada de `sTunTiles` em 96,320; origem embaixo no centro) |
| Luta com o chefe | Sala `rChefe` + objetos `oBoss*` (pasta "Chefe"). Veja a seção abaixo. |
| Câmera e parallax | `oCamera`, `oTunBackground` (5 planos `sTunBk1..5`). `global.cam_lock` = trava opcional (`{x, y, range}`), usada só pela arena do chefe; o `oCamera` zera ao começar cada sala. |
| Fonte com acentos | Press Start 2P em `datafiles/fonts` (licença SIL OFL junto), via `qrd_font(tamanho)`, sem antialias. Usar tamanhos múltiplos de 8 (8 no mundo dos túneis, 16/24 na GUI, 40/48 no título) |
| Teste automático | `objects/oQrdTest` (veja abaixo) |

## Luta com o chefe (`rChefe`)

Trecho final da `level_4_1` do jogo de referência (luta com o "RAY CAT", `obj_gemaboss` lá), recortado a partir de x = 3072 e convertido para a escala 2× dos túneis. Sala de 3872×1152, câmera 512×384. Dados recuperados (sala, código, sprites, prévia) em `Área de Trabalho\Starboy_boss_recuperado`.

1. **Chegada no escuro** (`oBossDark`: cor (36,20,44) com luz só em volta da Luma e do gato). Dois pilares sobre ácido, checkpoint no segundo, ponte da arena.
2. **Intro** (`oBossIntro`): o gato lambe a pata no parapeito; com a Luma a menos de 64 px ele grita ali mesmo, depois sobe reto do parapeito (0,8 px/frame) até a altura dos `oBossBound` e "estoura" → cria o `oBossCat`, apaga a escuridão, trava a câmera na arena (`oBossArena`, ±64 px de lado) e a camada `TilesScroll` desliza para a esquerda. (No original ele pulava no ácido e voltava; aqui fica na borda. O sprite `sChefeAcidSplash` ficou sem uso.)
3. **Chefe** (`oBossCat`), mesma máquina de estados/tempos do original, distâncias ×2:
   - estado 1: patrulha entre os dois `oBossBound` com 5 fantasmas (`oBossOrb`) em órbita; o anel abre após 2 batidas e fecha após 6; depois de 8 vai ao estado 2. A estátua (`oBossStatue`) fica acesa nos estados 1 e 6 e tiro nela também tira vida.
   - estado 2: parado, o lançador (`oBossShooter`) dispara balas grandes (`oBossBigShot`) pela direita por 600 frames.
   - estados 3–4: os fantasmas viram tiros (`oBossOrbShot`) mirados na Luma, primeiro um por vez, depois todos juntos.
   - estados 5–6: novo anel e volta ao 1. Abaixo de metade da vida, o lançador também atira na patrulha.
   - 400 de vida (1 por tiro), barra e nome (`boss_name`) no rodapé (Draw GUI).
4. **Derrota** (`oBossDeath`): treme e explode, sai pela esquerda, painel `global.boss_victory` (`scrQRD`) → menu.

Ácido mata na hora (como no original). Morrer reinicia a sala no checkpoint e a intro recomeça.

**Diferenças do original:** câmera mais estreita (512 contra 640 px; por isso a trava acompanha a Luma ±64 px); a Luma é menor que o personagem de referência, então as balas grandes podem passar por cima dela parada (ajuste = altura do lançador, `shooter_y` no Create do `oBossCat`); sem áudio; sem névoa, estrelas e linhas de velocidade.

**Mariana no lugar do gato:** `oBossIntro`, `oBossCat` e `oBossDeath` desenham a Mariana com `qrd_draw_mariana` (`scrQRD`). A arte (`sMariana`, do `Mariana.ase` da equipe, 80×80, escala 1, origem 40,46 = pés) tem 1 quadro só: os sprites do gato continuam tocando invisíveis (dão os tempos e os fins de animação) e viram movimento nela (flutuar, balançar, tremer no grito, crescer no estouro, inclinar no ataque, cair de lado triste). Olhos com íris vermelha + brilho aditivo `sMarianaGlow`. Nome na barra: MARIANA. Barra de vida (`sChefeHealth` quadro 1) em vermelho. Quando a equipe desenhar animações dela, trocar esses movimentos pelos quadros.

**Tiros do gato:** `oBossOrb` (em órbita) e `oBossOrbShot` (disparado) desenham `sChefeShot` (arte da equipe, 2 quadros 36×18, origem no centro): quadro 0 = bola, quadro 1 = tiro alongado girado na direção do voo. Os sprites do peixe (`sChefeOrbBody/Fin/Tail/Eyes`) ficaram sem uso.

**Paleta:** os 3 tilesets (`tChefeBoss`/`tChefeDarkest`/`tChefeUnder` e seus sprites `sChefeBoss`/`sChefeDarkest`/`sChefeUnder`) foram recoloridos para a paleta dos túneis a 80% do brilho; o ácido (bloco verde do `tChefeBoss`) ficou com a cor original. O parallax da sala (`sChefeBack`, desenhado por `oBossBackground`) usa os 3 verdes do `sTunTilesDark` (37,48,31 / 44,56,38 / 52,67,47). Os outros sprites do chefe e a escuridão (`oBossDark`) não mudaram.

**Assets:** `sChefe*` (30 sprites, origem e velocidade do original, 2×), tilesets `tChefeDarkest`/`tChefeUnder`/`tChefeBoss` (reconstruídos das texturas compiladas, com `output_tileset.png` no formato do IDE), objetos `oBoss*` (16).

## Arte

- **Luma, cetro e tiro:** arte da equipe do zip "SPRITES BIG" (80×80, desenhada com o dobro de detalhe). Desenhada em **meia escala**: com a câmera 2× dos túneis, cada pixel da arte vira um pixel de tela.
  - **Tamanho:** `QRD_LUMA_SCALE` (em `scrQRD`, hoje 0.75) aumenta só o desenho da Luma, do cetro e do corpo na morte, a partir dos pés; a colisão continua no `sPlayerMask`. A instância da Luma na sala deve ficar em escala 1 (o Create força isso).
  - `sPlayer` = parada, `sPlayerR` = corrida (4 quadros), `sPlayerA` = no ar (**provisório:** quadros 1 e 3 da corrida; falta arte de pulo/queda).
  - `sGun` = cetro deitado apontando para a direita; `sBullet` = 2 quadros 36×18 (saída do cetro, depois bola em voo com rastro; máscara 18×18 no centro).
  - `sBulletHit` = impacto em 3 quadros 36×18 (origem 32,9 = frente do impacto), tocado por `oBulletHit`. O `oBullet` cria o impacto no evento Destroy quando bate em parede, inimigo ou bloco; não cria quando expira no ar ou sai da sala (`impact = false`).
- **Painel dos registros/final (`oInfo`):** papel `sPaper` (9 peças 32×32 do pack "paperpack", "stained paper 2 (texture)"), desenhado em 2× com bordas e miolo repetidos em blocos de 64 px. **Crédito obrigatório: Robin Norkum / LCSkeleton** (licença em `datafiles/paperpack-LICENSE.txt`; colocar nos créditos do jogo/artigo). Textos: título 18 pt, resto 12 pt; rodapé e "ENTER" dividem a última linha.
- **Pergaminho dos registros (`sRecord`):** recuperado da Figura 2 do artigo (arte da equipe).
- **Fundo dos túneis:** os 5 planos `sTunBk*` tiveram o matiz girado de rosa para verde; cor de fundo da sala = verde (132,255,183).
- **Arte da equipe sem uso no jogo (mantida no projeto):** `sBackdropFar/Mid/Near`, `sGroundVisual`, `sGroundVisual4`, `sTiles`/`tTiles`, `Inimigo_morte`. A opção "remove unused assets" tira do executável.
- **Ainda não integrados do zip:** robôs novos (andando/correndo/boxeador), tiros do robô, coletável `.ase`, cenário "MontanhaPrediotomado".

## Como testar

O projeto tem um playtest automático (`oQrdTest`) que só liga com a variável de ambiente `QRD_AUTOTEST`. Ele testa movimento, pulo, tiro, plataforma, rampa, serra, inimigo, bloco, checkpoint/morte, os 5 registros e o final; grava `qrdtest_log.txt` e prints `qrdtest_*.png` em `%LOCALAPPDATA%\Platformer\`. Última rodada completa: **0 falhas** (antes da troca de arte da Luma e do fundo verde — rodar de novo).

Compilar pela linha de comando (de uma cópia do projeto, para não sujar o OneDrive):

```
"C:\ProgramData\GameMakerStudio2\Cache\runtimes\runtime-2024.14.4.268\bin\igor\windows\x64\Igor.exe" -j=8 --user="%APPDATA%\GameMakerStudio2\guilhermefiuza0211_5058547" --project="<copia>\Platformer.yyp" --runtimePath="C:\ProgramData\GameMakerStudio2\Cache\runtimes\runtime-2024.14.4.268" --runtime=VM --cache="<build>\cache" --temp="<build>\temp" -of="<build>\out\Platformer.win" -tf="<build>\out\Platformer.zip" -- Windows PackageZip
```

Depois, rodar `<build>\out\Platformer.exe` com `QRD_AUTOTEST=1` definido. A janela precisa ficar em foco (não mexer no PC durante o teste).

## Pendências

1. **Testar à mão** a Luma nova e o cetro: pés no chão, cetro na mão, tamanho na tela. Ajuste fino = origem dos sprites (`sPlayer` 40,32; `sPlayerR`/`sPlayerA` 40,26; `sGun` 2,15).
2. **Arte de pulo/queda da Luma** (hoje usa quadros da corrida).
3. **Origem da arte dos túneis e do chefe (`sTun*`, `sTunGrft_*`, `sChefe*`, `tChefe*`):** vem de um jogo de referência (Starboy Adventures, usado com autorização do autor) e não há crédito nem licença no projeto. Confirmar e creditar antes de publicar.
4. **Revisar com a equipe** os textos dos 5 registros, do final dos túneis e da vitória sobre o chefe (`global.boss_victory`) — rascunhos, em `scrQRD`. O nome "RAY CAT" (`boss_name` no `oBossCat`) é o do original.
5. **Testar à mão a `rChefe`** (ainda não foi jogada): escuridão e intro, trava da câmera, ciclo de ataques, dano na estátua, morte no ácido/reinício, vitória. O `oQrdTest` ainda não cobre esta sala.
6. **Artigo:** atualizar o trecho "sem uso de IA" (houve testes com SpriteCook, nenhum asset gerado ficou no jogo; textos e código tiveram ajuda de IA).
7. Integrar o restante do zip (robôs) se a equipe quiser.

## Backups (pasta `Documentos\Platformer\`)

- `_backup_antes_limpeza_2026-10-21` — projeto inteiro antes de apagar as salas antigas.
- `_backup_sprites_antes_luma_big` — sprites da Luma/arma/tiro anteriores.
- `_backup_jogador_provisorio` — primeira versão provisória da jogadora.
- `_backup_tiro_antes_impacto` — `sBullet` e `oBullet` antes do tiro/impacto novos.
- `_backup_chefe_paleta_original` — sprites `sChefe*`, tilesets `tChefe*`, `rChefe` e `oBossDark` antes da troca de paleta.
- `_backup_parallax_rosa` — planos do parallax e `rTuneis.yy` antes do verde.

O projeto **não está em git**; considere criar um repositório (o `.gitignore` já existe).
