function ecart = ecart_angulaire(N1, N2)
    ecart = real(mean(rad2deg(acos(sum(N1.*N2)))));
