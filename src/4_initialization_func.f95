module initialization_mod
    use parameters
    use auxiliary_mod
    implicit none
    real*8 :: T_avg
    real*8 :: T_stddev

contains
    !Density and Velocity ==============================================
    subroutine initialization_f()
        integer*8 :: i,x,y
        f   = 0
        rho = rho_0
        ux  = ux_0
        uy  = uy_0

        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                rho (x,y) = 0.d0
                ux  (x,y) = 0.d0
                uy  (x,y) = 0.d0
            end do
        end if

        rho_old = rho
        ux_old  = ux
        uy_old  = uy
        u_old   = ux*ux+uy*uy
        call equilibrium_func_f
        f = feq
    end subroutine initialization_f
    !======================================== Density and Velocity - End
    
    
    
    !Concentration ==============================================
    subroutine initialization_g()
        integer*8 :: i,x,y
        g = 0
        C = C_0

        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                C(x,y) = 0.d0
            end do

            ! do i = 1,n_ads_points_frontier
            !     x = mask_ads_frontier_x(i)
            !     y = mask_ads_frontier_y(i)
            !     C(x,y) = 0.d0
            ! end do

            do i = 1,n_ads_points
                x = mask_ads_x(i)
                y = mask_ads_y(i)
                C(x,y) = C_0_ads
            end do
        end if

        C_old = C
        call equilibrium_func_g
        g = geq
    end subroutine initialization_g
    !======================================== Concentration - End
    
    
    
    !Temperature ==============================================
    subroutine initialization_h()
        integer*8 :: i,x,y
        h = 0
        T = T_0

        if ( log_load_geometry ) then
            do i = 1,n_solid_points
                x = mask_x(i)
                y = mask_y(i)
                T(x,y) = T_0_solid
            end do

            do i = 1,n_ads_points
                x = mask_ads_x(i)
                y = mask_ads_y(i)
                T(x,y) = T_0_ads
            end do
        end if

        T_old = T
        call equilibrium_func_h
        h = heq
    end subroutine initialization_h
    !======================================== Temperature - End
    
    subroutine load_f()   
        integer :: i,x,y
        open(unit=20, file="paraview_read.dat", status="old", action="read")
        
        do i = 1, nx*ny
            x = i/ny + 1
            y = i - (x-1)*ny
            read(20, *) rho(x,y), u(x,y), ux(x,y), uy(x,y)
        end do
        close(20)
    end subroutine load_f

end module initialization_mod
