module thermalisation_mod
    use parameters
    implicit none

contains
    subroutine rattle_effect()
        integer :: i,x,y
        real*8 :: tau_h_rattle(nx,ny)
        real*8 :: matrix(nx,ny),matrix_fluid(nx,ny)
        real*8 :: b, a
        real*8 :: C_max

        C_max = 0.99*k_H*C_0

        a = tau_h_ads*(0.7-exp(-C_max))/(1-exp(-C_max))
        b = tau_h_ads

        tau_h_rattle = tau_h

        do i = 1,n_ads_points
            x = mask_ads_x(i)
            y = mask_ads_y(i)
            !Linear Decay
            ! tau_h_rattle(x,y) = -tau_h_ads/(k_H*C_0)*0.3*C(x,y)+tau_h_ads

            !Exponencial Decay
            tau_h_rattle(x,y) = (b-a)*exp(-C(x,y)) + a
        end do
        inv_tau_h_matrix = 1/tau_h_rattle
    end subroutine rattle_effect


    subroutine thermalisation()
        implicit none
        integer*8 :: x,y,dir
        
        do dir = 1,Q
            ! do x = 1,nx
            !     do y = 1,ny
            !         if ( lattice_mask(x,y) == 2) then
            !             h_ttt(x,y,dir) = h_tt(x,y,dir)*(1+zeta*(T_w-T_tt(x,y))/T_tt(x,y))
            !         end if
            !     end do
            ! end do
            !BOTTOM
            h_t(:,1,dir) = h_t(:,1,dir)*(1+zeta*(T_bottom-T(:,1))/T(:,1))
            ! !TOP
            h_t(:,ny,dir) = h_t(:,ny,dir)*(1+zeta*(T_top-T(:,ny))/T(:,ny))
            !LEFT
            ! h_t(1,:,dir) = h_t(1,:,dir)*(1+zeta*(T_wall-T(1,:))/T(1,:))
            ! !RIGHT
            ! h_t(nx,:,dir) = h_t(nx,:,dir)*(1+zeta*(T_wall-T(nx,:))/T(nx,:))
        end do
    end subroutine thermalisation

    ! subroutine thermalisation_stokes()
    !     implicit none
    !     integer*8 :: dir

    !     h_tt = h_t

    !     !IN ADSORPTION REGION
    !     do dir = 1,Q
    !         h_tt(:,1,dir) = h_t(:,1,dir)*(1+zeta*(T_B-T_t(:,1))/T_t(:,1))
    !         h_tt(:,ny,dir) = h_t(:,ny,dir)*(1+zeta*(T_Top-T_t(:,ny))/T_t(:,ny))
    !     end do
    ! end subroutine thermalisation_stokes
end module