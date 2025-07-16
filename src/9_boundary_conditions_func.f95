module boundary_conditions_mod
    use parameters
    implicit none
    
contains

    subroutine boundary_conditions_f()
        if      ( bc_cmd_f == 1 ) then
            call bounce_back_f
        else if ( bc_cmd_f == 2 ) then
            !Walls
            call zou_he_left_velocity
            !call zou_he_right_velocity
            call zou_he_right_pressure
            call zou_he_bottom_velocity
            call zou_he_top_velocity
            !Corners
            call zou_he_bottom_left_corner_velocity
            call zou_he_bottom_right_corner_velocity
            call zou_he_top_left_corner_velocity
            call zou_he_top_right_corner_velocity
        end if
    end subroutine boundary_conditions_f

    subroutine boundary_conditions_g()
        if      ( bc_cmd_g == 1 ) then
            call bounce_back_g
        else if ( bc_cmd_g == 2 ) then
            call inamuro_left_g
            call inamuro_right_g
            !TOP
            g(:,ny,4)   = g_t(:,ny,2)
            g(:,ny,7)   = g_t(:,ny,5)
            g(:,ny,8)   = g_t(:,ny,6)
            !BOTTOM
            g(:,1,2)    = g_t(:,1,4)
            g(:,1,5)    = g_t(:,1,7)
            g(:,1,6)    = g_t(:,1,8)  
        end if
    end subroutine boundary_conditions_g

    subroutine boundary_conditions_h()
        real*8, parameter :: zeta = 1.5d0
        integer :: dir
        real*8, parameter :: T_w = 1.d0

        if      ( bc_cmd_h == 1 ) then
            call bounce_back_h
        else if ( bc_cmd_h == 2 ) then
            !LEFT
            h(1,:,1)    = h_t(1,:,3)
            h(1,:,5)    = h_t(1,:,7)
            h(1,:,8)    = h_t(1,:,6)
            !RIGHT
            h(nx,:,3)   = h_t(nx,:,1)
            h(nx,:,7)   = h_t(nx,:,5)
            h(nx,:,6)   = h_t(nx,:,8)
            do dir = 1, 9
                h(:,1,dir) = h_t(:,1,dir)*(1+zeta*(T_w-T(:,1))/T(:,1))
                h(:,ny,dir) = h_t(:,ny,dir)*(1+zeta*(T_w-T(:,ny))/T(:,ny))
            end do
        end if
    end subroutine boundary_conditions_h

!BOUNCE-BACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    subroutine bounce_back_f()
        !LEFT
        f(1,:,1)    = f_t(1,:,3)
        f(1,:,5)    = f_t(1,:,7)
        f(1,:,8)    = f_t(1,:,6)
        !RIGHT
        f(nx,:,3)   = f_t(nx,:,1)
        f(nx,:,7)   = f_t(nx,:,5)
        f(nx,:,6)   = f_t(nx,:,8)
        !TOP
        f(:,ny,4)   = f_t(:,ny,2)
        f(:,ny,7)   = f_t(:,ny,5)
        f(:,ny,8)   = f_t(:,ny,6)
        !BOTTOM
        f(:,1,2)    = f_t(:,1,4)
        f(:,1,5)    = f_t(:,1,7)
        f(:,1,6)    = f_t(:,1,8)
    end subroutine bounce_back_f

    subroutine bounce_back_g()
        !LEFT
        g(1,:,1)    = g_t(1,:,3)
        g(1,:,5)    = g_t(1,:,7)
        g(1,:,8)    = g_t(1,:,6)
        !RIGHT
        g(nx,:,3)   = g_t(nx,:,1)
        g(nx,:,7)   = g_t(nx,:,5)
        g(nx,:,6)   = g_t(nx,:,8)
        !TOP
        g(:,ny,4)   = g_t(:,ny,2)
        g(:,ny,7)   = g_t(:,ny,5)
        g(:,ny,8)   = g_t(:,ny,6)
        !BOTTOM
        g(:,1,2)    = g_t(:,1,4)
        g(:,1,5)    = g_t(:,1,7)
        g(:,1,6)    = g_t(:,1,8)
    end subroutine bounce_back_g

    subroutine bounce_back_h()
        !LEFT
        h(1,:,1)    = h_t(1,:,3)
        h(1,:,5)    = h_t(1,:,7)
        h(1,:,8)    = h_t(1,:,6)
        !RIGHT
        h(nx,:,3)   = h_t(nx,:,1)
        h(nx,:,7)   = h_t(nx,:,5)
        h(nx,:,6)   = h_t(nx,:,8)
        !TOP
        h(:,ny,4)   = h_t(:,ny,2)
        h(:,ny,7)   = h_t(:,ny,5)
        h(:,ny,8)   = h_t(:,ny,6)
        !BOTTOM
        h(:,1,2)    = h_t(:,1,4)
        h(:,1,5)    = h_t(:,1,7)
        h(:,1,6)    = h_t(:,1,8)
    end subroutine bounce_back_h

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    subroutine zou_he_left_velocity()
        ux(1,:) = ux_L
        rho(1,:) = (f(1,:,9)+f(1,:,2)+f(1,:,4)+2*(f(1,:,3)+f(1,:,6)+f(1,:,7)))/(1-ux(1,:))
        f(1,:,1) = f(1,:,3)+cst1*rho(1,:)*ux(1,:)
        f(1,:,5) = f(1,:,7)-cst3*(f(1,:,2)-f(1,:,4))+cst2*rho(1,:)*ux(1,:)+cst3*rho(1,:)*uy_L
        f(1,:,8) = f(1,:,6)+cst3*(f(1,:,2)-f(1,:,4))+cst2*rho(1,:)*ux(1,:)-cst3*rho(1,:)*uy_L
    end subroutine zou_he_left_velocity

    subroutine zou_he_right_velocity()
        rho(nx,:) = (f(nx,:,9)+f(nx,:,2)+f(nx,:,4)+2*(f(nx,:,1)+f(nx,:,5)+f(nx,:,8)))/(1-ux_R)
        f(nx,:,3) = f(nx,:,1)-cst1*rho(nx,:)*ux_R
        f(nx,:,7) = f(nx,:,5)+cst3*(f(nx,:,2)-f(nx,:,4))-cst2*rho(nx,:)*ux_R-cst3*rho(nx,:)*uy_R
        f(nx,:,6) = f(nx,:,8)-cst3*(f(nx,:,2)-f(nx,:,4))-cst2*rho(nx,:)*ux_R-cst3*rho(nx,:)*uy_R
    end subroutine zou_he_right_velocity

    subroutine zou_he_right_pressure()
        ux(nx,:) = (f(nx,:,9)+f(nx,:,2)+f(nx,:,4)+2*(f(nx,:,1)+f(nx,:,5)+f(nx,:,8)))/rho_R - 1
        f(nx,:,3) = f(nx,:,1)-cst1*rho(nx,:)*ux(nx,:)
        f(nx,:,7) = f(nx,:,5)+cst3*(f(nx,:,2)-f(nx,:,4))-cst2*rho_R*ux(nx,:)-cst3*rho_R*uy_R
        f(nx,:,6) = f(nx,:,8)-cst3*(f(nx,:,2)-f(nx,:,4))-cst2*rho_R*ux(nx,:)-cst3*rho_R*uy_R
    end subroutine zou_he_right_pressure

    subroutine zou_he_top_velocity()
        rho(:,ny) = (f(:,ny,9)+f(:,ny,1)+f(:,ny,3)+2*(f(:,ny,2)+f(:,ny,5)+f(:,ny,6)))/(1+uy_Top)
        f(:,ny,4) = f(:,ny,2)-cst1*rho(:,ny)*uy_Top
        f(:,ny,8) = f(:,ny,6)-cst3*(f(:,ny,1)-f(:,ny,3))+cst3*rho(:,ny)*ux_Top-cst2*rho(:,ny)*uy_Top
        f(:,ny,7) = f(:,ny,5)+cst3*(f(:,ny,1)-f(:,ny,3))-cst3*rho(:,ny)*ux_Top-cst2*rho(:,ny)*uy_Top
    end subroutine zou_he_top_velocity

    subroutine zou_he_bottom_velocity()
        rho(:,1) = (f(:,1,9)+f(:,1,1)+f(:,1,3)+2*(f(:,1,4)+f(:,1,7)+f(:,1,8)))/(1-uy_B)
        f(:,1,2) = f(:,1,4)+cst1*rho(:,1)*uy_B
        f(:,1,5) = f(:,1,7)-cst3*(f(:,1,1)-f(:,1,3))+cst3*rho(:,1)*ux_B+cst2*rho(:,1)*uy_B
        f(:,1,6) = f(:,1,8)+cst3*(f(:,1,1)-f(:,1,3))-cst3*rho(:,1)*ux_B+cst2*rho(:,1)*uy_B  
    end subroutine zou_he_bottom_velocity

    subroutine zou_he_bottom_left_corner_velocity()
        ux (1,1) = ux(2,1)
        uy (1,1) = uy(2,1)
        rho(1,1) = rho(2,1)

        f(1,1,1) = f(1,1,3) + cst1*rho(1,1)*ux(1,1)
        f(1,1,2) = f(1,1,4) + cst1*rho(1,1)*uy(1,1)
        f(1,1,5) = f(1,1,7) + cst2*rho(1,1)*ux(1,1)+cst2*rho(1,1)*uy(1,1)

        f(1,1,6) = 0
        f(1,1,8) = 0

        f(1,1,9) = rho(1,1) - f(1,1,1) - f(1,1,2) - f(1,1,3)& 
        - f(1,1,4) - f(1,1,5) - f(1,1,6) - f(1,1,7) - f(1,1,8)
    end subroutine zou_he_bottom_left_corner_velocity

    subroutine zou_he_top_left_corner_velocity()
        ux (1,ny) = ux(2,ny)
        uy (1,ny) = uy(2,ny)
        rho(1,ny) = rho(2,ny)

        f(1,ny,1) = f(1,ny,3) + cst1*rho(1,ny)*ux(1,ny)
        f(1,ny,4) = f(1,ny,2) - cst1*rho(1,ny)*uy(1,ny)
        f(1,ny,8) = f(1,ny,6) + cst2*rho(1,ny)*ux(1,ny)-cst2*rho(1,ny)*uy(1,ny)

        f(1,ny,5) = 0
        f(1,ny,7) = 0

        f(1,ny,9) = rho(1,ny) - f(1,ny,1) - f(1,ny,2) - f(1,ny,3) &
        - f(1,ny,4) - f(1,ny,5) - f(1,ny,6) - f(1,ny,7) - f(1,ny,8)
    end subroutine zou_he_top_left_corner_velocity

    subroutine zou_he_bottom_right_corner_velocity()
        ux (nx,1) = ux(lx,1)
        uy (nx,1) = uy(lx,1)
        rho(nx,1) = rho(lx,1)

        f(nx,1,3) = f(nx,1,1) - cst1*rho(nx,1)*ux(nx,1)
        f(nx,1,2) = f(nx,1,4) + cst1*rho(nx,1)*uy(nx,1)
        f(nx,1,6) = f(nx,1,8) - cst2*rho(nx,1)*ux(nx,1)+cst2*rho(nx,1)*uy(nx,1)

        f(nx,1,5) = 0
        f(nx,1,7) = 0

        f(nx,1,9) = rho(nx,1) - f(nx,1,1) - f(nx,1,2) - f(nx,1,3)&
        - f(nx,1,4) - f(nx,1,5) - f(nx,1,6) - f(nx,1,7) - f(nx,1,8)
    end subroutine zou_he_bottom_right_corner_velocity

    subroutine zou_he_top_right_corner_velocity()
        ux (nx,ny) = ux(lx,ny)
        uy (nx,ny) = uy(lx,ny)
        rho(nx,ny) = rho(lx,ny)

        f(nx,ny,3) = f(nx,ny,1) - cst1*rho(nx,ny)*ux(nx,ny)
        f(nx,ny,4) = f(nx,ny,2) - cst1*rho(nx,ny)*uy(nx,ny)
        f(nx,ny,7) = f(nx,ny,5) - cst2*rho(nx,ny)*ux(nx,ny)-cst2*rho(nx,ny)*uy(nx,ny)

        f(nx,ny,6) = 0
        f(nx,ny,8) = 0

        f(nx,ny,9) = rho(nx,ny) - f(nx,ny,1) - f(nx,ny,2) - f(nx,ny,3) &
        - f(nx,ny,4) - f(nx,ny,5) - f(nx,ny,6) - f(nx,ny,7) - f(nx,ny,8)
    end subroutine zou_he_top_right_corner_velocity

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    subroutine inamuro_left_g()
        implicit none
        real*8 :: T_inamuro_L(ny)
        real*8 :: E_1(ny),E_5(ny),E_8(ny)
        E_1 = (1+ux_L*inv_cs2+ux_L*ux_L*inv_2cs4-(ux_L*ux_L+uy_L*uy_L)*0.5*inv_cs2)
        E_5 = (1+(ux_L+uy_L)*inv_cs2+(ux_L+uy_L)*(ux_L+uy_L)*inv_2cs4-(ux_L*ux_L+uy_L*uy_L)*0.5*inv_cs2)
        E_8 = (1+(ux_L-uy_L)*inv_cs2+(ux_L-uy_L)*(ux_L-uy_L)*inv_2cs4-(ux_L*ux_L+uy_L*uy_L)*0.5*inv_cs2)
        
        T_inamuro_L = (C_L - (g(1,:,9)+g(1,:,2)+g(1,:,3)+g(1,:,4)+g(1,:,6)&
            +g(1,:,7)))/(w(1)*E_1+w(5)*E_5+w(8)*E_8)

        g(1,:,1) = w(1)*T_inamuro_L*E_1
        g(1,:,5) = w(5)*T_inamuro_L*E_5
        g(1,:,8) = w(8)*T_inamuro_L*E_8
    end subroutine inamuro_left_g

    subroutine inamuro_right_g()
        implicit none
        real*8 :: T_inamuro_R(ny)
        real*8 :: E_3(ny),E_6(ny),E_7(ny)
        E_3 = (1-u(nx,:)*inv_cs2+u(nx,:)*u(nx,:)*inv_2cs4-(u(nx,:)*u(nx,:)+uy_R*uy_R)*0.5*inv_cs2)
        E_6 = (1+(-u(nx,:)+uy_R)*inv_cs2+(-u(nx,:)+uy_R)*(-u(nx,:)+uy_R)*inv_2cs4-(u(nx,:)*u(nx,:)+uy_R*uy_R)*0.5*inv_cs2)
        E_7 = (1+(-u(nx,:)-uy_R)*inv_cs2+(u(nx,:)+uy_R)*(u(nx,:)+uy_R)*inv_2cs4-(u(nx,:)*u(nx,:)+uy_R*uy_R)*0.5*inv_cs2)
        
        T_inamuro_R = (C_R - (g(nx,:,9)+g(nx,:,1)+g(nx,:,2)+g(nx,:,4)+g(nx,:,5)&
            +g(nx,:,8)))/(w(3)*E_3+w(6)*E_6+w(7)*E_7)

        g(nx,:,3) = w(3)*T_inamuro_R*E_3
        g(nx,:,6) = w(6)*T_inamuro_R*E_6
        g(nx,:,7) = w(7)*T_inamuro_R*E_7
    end subroutine inamuro_right_g

end module boundary_conditions_mod
