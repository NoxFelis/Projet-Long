ecart_N1 = ecart_angulaire(N_gray, N_1);
ecart_N2 = ecart_angulaire(N_gray, N_2);
ecart_N3 = ecart_angulaire(N_gray, N_3);
ecart_N4 = ecart_angulaire(N_gray, N_4);
ecart_NHDR = ecart_angulaire(N_gray, N_HDR);

ecart_12 = ecart_angulaire(N_1, N_2);
ecart_13 = ecart_angulaire(N_1, N_3);
ecart_14 = ecart_angulaire(N_1, N_4);
ecart_1HDR = ecart_angulaire(N_1, N_HDR);

ecart_23 = ecart_angulaire(N_2, N_3);
ecart_24 = ecart_angulaire(N_2, N_4);
ecart_2HDR = ecart_angulaire(N_2, N_HDR);

ecart_34 = ecart_angulaire(N_3, N_4);
ecart_3HDR = ecart_angulaire(N_3, N_HDR);

ecart_4HDR = ecart_angulaire(N_4, N_HDR);

diff_N1 = mean(abs(rho_gray(:) - rho_1(:)));
diff_N2 = mean(abs(rho_gray(:) - rho_2(:)));
diff_N3 = mean(abs(rho_gray(:) - rho_3(:)));
diff_N4 = mean(abs(rho_gray(:) - rho_4(:)));
diff_NHDR = mean(abs(rho_gray(:) - rho_HDR(:)));

diff_12 = mean(abs(rho_1(:) - rho_2(:)));
diff_13 = mean(abs(rho_1(:) - rho_3(:)));
diff_14 = mean(abs(rho_1(:) - rho_4(:)));
diff_1HDR = mean(abs(rho_1(:) - rho_HDR(:)));


diff_23 = mean(abs(rho_2(:) - rho_3(:)));
diff_24 = mean(abs(rho_2(:) - rho_4(:)));
diff_2HDR = mean(abs(rho_2(:) - rho_HDR(:)));

diff_34 = mean(abs(rho_3(:) - rho_4(:)));
diff_3HDR = mean(abs(rho_3(:) - rho_HDR(:)));

diff_4HDR = mean(abs(rho_4(:) - rho_HDR(:)));

mat_ecart = [0 0 ExposureTime(1, 1) ExposureTime(1, 2) ExposureTime(1, 3) ExposureTime(1, 4) inf;
    0 0 ecart_N1 ecart_N2 ecart_N3 ecart_N4 ecart_NHDR;
    ExposureTime(1, 1) ecart_N1 0 ecart_12 ecart_13 ecart_14 ecart_1HDR;
    ExposureTime(1, 2) ecart_N2 ecart_12 0 ecart_23 ecart_24 ecart_2HDR;
    ExposureTime(1, 3) ecart_N3 ecart_13 ecart_23 0 ecart_34 ecart_3HDR;
    ExposureTime(1, 4) ecart_N4 ecart_14 ecart_24 ecart_34 0 ecart_4HDR;
    1 ecart_NHDR ecart_1HDR ecart_2HDR ecart_3HDR ecart_4HDR 0]

mat_diff = [0 0 ExposureTime(1, 1) ExposureTime(1, 2) ExposureTime(1, 3) ExposureTime(1, 4) inf;
    0 0 diff_N1 diff_N2 diff_N3 diff_N4 diff_NHDR;
    ExposureTime(1, 1) diff_N1 0 diff_12 diff_13 diff_14 diff_1HDR;
    ExposureTime(1, 2) diff_N2 diff_12 0 diff_23 diff_24 diff_2HDR;
    ExposureTime(1, 3) diff_N3 diff_13 diff_23 0 diff_34 diff_3HDR;
    ExposureTime(1, 4) diff_N4 diff_14 diff_24 diff_34 0 diff_4HDR;
    1 diff_NHDR diff_1HDR diff_2HDR diff_3HDR diff_4HDR 0]
