% function dedirs_ge_52 gives DE_scheme with b0s if amount of b0s is given
% SuS April 2008 (copied from original tensor.dat file)

function DE_scheme = dedirs_ge_52(nob0s)

if nargin == 0
    DE_scheme = [0.416971183993 -0.800108574471 -0.431232304885;...
        -0.478160533337 0.736772429745 -0.478046954939;...
        -0.218896429162 -0.039479877852 0.974949071770;...
        0.243161798996 -0.838340787703 0.487910917261;...
        0.230875742318 0.329445213124 -0.915512011477;...
        0.410615081877 -0.464321961026 0.784729489088;...
        0.837490267717 -0.528837748436 -0.137625169602;...
        -0.926520772745 0.266829853761 0.265256643300;...
        0.851910807978 0.482655934494 -0.203202421610;...
        -0.801215206184 -0.248157885467 -0.544492293114;...
        -0.984515763801 0.041162384930 -0.170394744330;...
        -0.770928995335 0.319775506339 -0.550828566523;...
        0.034539937131 -0.999303379203 0.014133260677;...
        0.312643907190 0.747532471575 0.586045212623;...
        -0.078289149167 0.961561326103 -0.263193133013;...
        0.910646449751 0.308314661046 0.275072923677;...
        -0.804267550227 0.583929202552 -0.110364822557;...
        0.647851839596 0.729720182278 0.218623991154;...
        -0.568096921506 -0.692958167045 -0.443931150632;...
        0.716831388699 -0.572694080252 0.397711265391;...
        -0.701521235840 0.084769400408 0.707588937464;...
        0.293576563703 -0.021193916490 0.955700590744;...
        0.503411473027 -0.862953389394 0.043454994641;...
        -0.440677232733 -0.897422065932 -0.020909618086;...
        -0.540207910032 -0.392075514725 0.744615474384;...
        -0.652501746619 0.619341032676 0.436644198293;...
        0.612312103503 0.373868468860 0.696632080725;...
        -0.435125495242 0.897452226614 0.072424473322;...
        -0.375800545201 0.427140890784 0.822389572920;...
        -0.294459857877 0.430822706491 -0.853044657489;...
        -0.087979663444 -0.878617618448 -0.469351317643;...
        0.423079263126 -0.142619073794 -0.894798154280;...
        0.707756639883 -0.396494168980 -0.584698993216;...
        0.743970173749 -0.090556730259 0.662048230250;...
        0.743824920129 0.146914637182 -0.652028049686;...
        -0.240798829805 -0.839629473694 0.486865762268;...
        -0.525213942616 -0.006017644395 -0.850948942321;...
        0.967933457454 -0.014948622926 -0.250761561275;...
        -0.913594597626 -0.217140115365 0.343795115567;...
        -0.191267338197 0.815833017992 0.545741048570;...
        -0.319697875088 -0.491331424317 -0.810176956068;...
        -0.673181917375 -0.654879228571 0.343452037562;...
        0.961961294234 -0.171497109789 0.212648088939;...
        0.104889227913 0.424516691722 0.899324095261;...
        0.541898990433 0.586983658864 -0.601494528981;...
        -0.872455645647 -0.479896206606 -0.092308056326;...
        -0.062364879065 -0.081226949494 -0.994742582046;...
        0.129079358522 0.974960279012 0.181082780936;...
        -0.068267747908 -0.514331516090 0.854869935225;...
        0.179325041353 -0.566911263349 -0.804023724172;...
        0.440578561317 0.870449917394 -0.219562001757;...
        0.058544481762 0.743454307625 -0.666219360367];
elseif nargin == 1
    DE_scheme = [zeros(nob0s,3);...
        0.416971183993 -0.800108574471 -0.431232304885;...
        -0.478160533337 0.736772429745 -0.478046954939;...
        -0.218896429162 -0.039479877852 0.974949071770;...
        0.243161798996 -0.838340787703 0.487910917261;...
        0.230875742318 0.329445213124 -0.915512011477;...
        0.410615081877 -0.464321961026 0.784729489088;...
        0.837490267717 -0.528837748436 -0.137625169602;...
        -0.926520772745 0.266829853761 0.265256643300;...
        0.851910807978 0.482655934494 -0.203202421610;...
        -0.801215206184 -0.248157885467 -0.544492293114;...
        -0.984515763801 0.041162384930 -0.170394744330;...
        -0.770928995335 0.319775506339 -0.550828566523;...
        0.034539937131 -0.999303379203 0.014133260677;...
        0.312643907190 0.747532471575 0.586045212623;...
        -0.078289149167 0.961561326103 -0.263193133013;...
        0.910646449751 0.308314661046 0.275072923677;...
        -0.804267550227 0.583929202552 -0.110364822557;...
        0.647851839596 0.729720182278 0.218623991154;...
        -0.568096921506 -0.692958167045 -0.443931150632;...
        0.716831388699 -0.572694080252 0.397711265391;...
        -0.701521235840 0.084769400408 0.707588937464;...
        0.293576563703 -0.021193916490 0.955700590744;...
        0.503411473027 -0.862953389394 0.043454994641;...
        -0.440677232733 -0.897422065932 -0.020909618086;...
        -0.540207910032 -0.392075514725 0.744615474384;...
        -0.652501746619 0.619341032676 0.436644198293;...
        0.612312103503 0.373868468860 0.696632080725;...
        -0.435125495242 0.897452226614 0.072424473322;...
        -0.375800545201 0.427140890784 0.822389572920;...
        -0.294459857877 0.430822706491 -0.853044657489;...
        -0.087979663444 -0.878617618448 -0.469351317643;...
        0.423079263126 -0.142619073794 -0.894798154280;...
        0.707756639883 -0.396494168980 -0.584698993216;...
        0.743970173749 -0.090556730259 0.662048230250;...
        0.743824920129 0.146914637182 -0.652028049686;...
        -0.240798829805 -0.839629473694 0.486865762268;...
        -0.525213942616 -0.006017644395 -0.850948942321;...
        0.967933457454 -0.014948622926 -0.250761561275;...
        -0.913594597626 -0.217140115365 0.343795115567;...
        -0.191267338197 0.815833017992 0.545741048570;...
        -0.319697875088 -0.491331424317 -0.810176956068;...
        -0.673181917375 -0.654879228571 0.343452037562;...
        0.961961294234 -0.171497109789 0.212648088939;...
        0.104889227913 0.424516691722 0.899324095261;...
        0.541898990433 0.586983658864 -0.601494528981;...
        -0.872455645647 -0.479896206606 -0.092308056326;...
        -0.062364879065 -0.081226949494 -0.994742582046;...
        0.129079358522 0.974960279012 0.181082780936;...
        -0.068267747908 -0.514331516090 0.854869935225;...
        0.179325041353 -0.566911263349 -0.804023724172;...
        0.440578561317 0.870449917394 -0.219562001757;...
        0.058544481762 0.743454307625 -0.666219360367];
elseif nargin > 1
    disp('Error: too many input arguments');
end
DE_scheme = [DE_scheme(:,2) DE_scheme(:,1) -DE_scheme(:,3)];
