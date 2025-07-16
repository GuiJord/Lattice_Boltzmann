module auxiliary_mod
    use geometry_mod
    use parameters
    implicit none

    contains

    !================================== Moments Calculation - Beginning ============================================

    subroutine moments_f()
        call calc_density
        call calc_velocity
    end subroutine moments_f

    subroutine moments_g()
        call calc_concentration
    end subroutine moments_g
   
    subroutine moments_h()
        call calc_temperature
    end subroutine moments_h

    !Density and Velocity ==============================================
    !Calculate Density
    subroutine calc_density()
        integer*8 :: x,y,i
        rho = sum(f,dim=3)
        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                rho(x,y) = 0.d0
            end do
        end if
    end subroutine calc_density 

    !Calculate Velocity
    subroutine calc_velocity()
        integer*8 :: i,x,y
        real*8 :: rho_,ux_,uy_
        real*8 :: f1,f2,f3,f4,f5,f6,f7,f8
        
        if ( log_load_geometry ) then
            do i = 1,n_fluid_points
                x = fluid_mask_x(i)
                y = fluid_mask_y(i)
                rho_ = rho(x,y)
                f1 = f(x,y,1)
                f2 = f(x,y,2)
                f3 = f(x,y,3)
                f4 = f(x,y,4)
                f5 = f(x,y,5)
                f6 = f(x,y,6)
                f7 = f(x,y,7)
                f8 = f(x,y,8)
    
                ux_ = f1-f3+f5-f6-f7+f8
                uy_ = f2-f4+f6+f5-f7-f8
                
                ux(x,y) = ux_/rho_
                uy(x,y) = uy_/rho_
            end do
        else
            ux = 1/rho*(f(:,:,1)-f(:,:,3)+f(:,:,5)-f(:,:,6)-f(:,:,7)+f(:,:,8))
            uy = 1/rho*(f(:,:,2)-f(:,:,4)+f(:,:,6)+f(:,:,5)-f(:,:,7)-f(:,:,8))
        end if
        u = sqrt(ux*ux+uy*uy)
    end subroutine calc_velocity
    !======================================== Density and Velocity - End
    
    
    !Concentration ==============================================
    subroutine calc_concentration()
        integer*8 :: x,y,i
        C = sum(g,dim=3)
        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                C(x,y) = 0.d0
            end do
        end if
    end subroutine calc_concentration
    !======================================== Concentration - End
    
    
    !Temperature ==============================================
    subroutine calc_temperature()
        integer*8 :: x,y,i
        T = sum(h,dim=3)
        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                T(x,y) = 0.d0
            end do
        end if
    end subroutine calc_temperature
    !======================================== Temperature - End
    
    !================================== Moments Calculation - End ==================================================
    

    
    !================================== Error Calculation - Beginning ============================================

    subroutine error_f()
        call calc_error_rho
        call calc_error_ux
        call calc_error_uy
        call calc_error_u
    end subroutine error_f

    !Density
    subroutine calc_error_rho()
        error_rho = sum(abs(rho-rho_old))/sum(rho_old)
    end subroutine calc_error_rho

    !Velocity x
    subroutine calc_error_ux()
        error_ux = sum(abs(ux-ux_old))/sum(abs(ux_old))
    end subroutine calc_error_ux

    !Velocity y
    subroutine calc_error_uy()
        error_uy = sum(abs(uy-uy_old))/sum(abs(uy_old))
    end subroutine calc_error_uy

    !Velocity
    subroutine calc_error_u()
        error_u = sum(abs(u-u_old))/sum(u_old)
    end subroutine calc_error_u

    !Concentration
    subroutine error_g()
        error_C = sum(abs(C-C_old))/sum(C_old)
    end subroutine error_g

    !Temperature
    subroutine error_h()
        error_T = sum(abs(T-T_old))/sum(T_old)
    end subroutine error_h
    !================================== Error Calculation - End ==================================================
    

    
    !================================== Updating - Beginning ============================================
    subroutine update_f()
        rho_old = rho
        ux_old  = ux
        uy_old  = uy
        u_old   = u
    end subroutine update_f

    subroutine update_g()
        C_old = C
    end subroutine update_g

    subroutine update_h()
        T_old = T
    end subroutine update_h    
    !================================== Updating - End ==================================================
    
    
    
    !================================== Equilibrium Function Calculation - Beginning ============================================
    subroutine equilibrium_func_f()
        feq(:,:,9) = w(9)*rho*(1-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,1) = w(1)*rho*(1+ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,2) = w(2)*rho*(1+uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,3) = w(3)*rho*(1-ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,4) = w(4)*rho*(1-uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,5) = w(5)*rho*(1+(ux+uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,6) = w(6)*rho*(1+(-ux+uy)*inv_cs2+(-ux+uy)*(-ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,7) = w(7)*rho*(1+(-ux-uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        feq(:,:,8) = w(8)*rho*(1+(ux-uy)*inv_cs2+(ux-uy)*(ux-uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
    end subroutine equilibrium_func_f

    subroutine equilibrium_func_g()
        geq(:,:,9) = w(9)*C*(1-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,1) = w(1)*C*(1+ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,2) = w(2)*C*(1+uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,3) = w(3)*C*(1-ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,4) = w(4)*C*(1-uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,5) = w(5)*C*(1+(ux+uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,6) = w(6)*C*(1+(-ux+uy)*inv_cs2+(-ux+uy)*(-ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,7) = w(7)*C*(1+(-ux-uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        geq(:,:,8) = w(8)*C*(1+(ux-uy)*inv_cs2+(ux-uy)*(ux-uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
    end subroutine equilibrium_func_g

    subroutine equilibrium_func_h()
        heq(:,:,9) = w(9)*T*(1-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,1) = w(1)*T*(1+ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,2) = w(2)*T*(1+uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,3) = w(3)*T*(1-ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,4) = w(4)*T*(1-uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,5) = w(5)*T*(1+(ux+uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,6) = w(6)*T*(1+(-ux+uy)*inv_cs2+(-ux+uy)*(-ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,7) = w(7)*T*(1+(-ux-uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        heq(:,:,8) = w(8)*T*(1+(ux-uy)*inv_cs2+(ux-uy)*(ux-uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
    end subroutine equilibrium_func_h

    subroutine calc_w_E()
        w_E(:,:,9) = w(9)*(1-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,1) = w(1)*(1+ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,2) = w(2)*(1+uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,3) = w(3)*(1-ux*inv_cs2+ux*ux*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,4) = w(4)*(1-uy*inv_cs2+uy*uy*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,5) = w(5)*(1+(ux+uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,6) = w(6)*(1+(-ux+uy)*inv_cs2+(-ux+uy)*(-ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,7) = w(7)*(1+(-ux-uy)*inv_cs2+(ux+uy)*(ux+uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
        w_E(:,:,8) = w(8)*(1+(ux-uy)*inv_cs2+(ux-uy)*(ux-uy)*inv_2cs4-(ux*ux+uy*uy)*0.5*inv_cs2)
    end subroutine calc_w_E
    !================================== Equilibrium Function Calculation - End ==================================================    
    
    
    
    !von Kàrmàn Tests ==============================================
    subroutine tortuosity_calc()
        integer :: x,y,y_op
        tortuosity = 0
        do x = 1,nx
            do y = 1,ny/2
                y_op = ny - y
                tortuosity = tortuosity + (abs(ux(x,y)-ux(x,y_op))+abs(uy(x,y)-uy(x,y_op)))      
            end do
        end do
        tortuosity = tortuosity/(nx*ny*ux_L)
    end subroutine tortuosity_calc

    subroutine error_tortuosity_calc()
        error_tortuosity = abs(tortuosity-tortuosity_old)/tortuosity_old
    end subroutine error_tortuosity_calc
    !======================================== vonKàrmàn Tests - End
    
end module auxiliary_mod

