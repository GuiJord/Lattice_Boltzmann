module collision_mod
    use parameters
    implicit none
    
contains

    !================================== Collision - Beginning ============================================
    subroutine collision_f()
        if      (col_cmd == 1) then
            call collision_BGK_f
        else if (col_cmd == 2) then
            call collision_TRT_f
        else if (col_cmd == 3) then
            call collision_MRT_f
        end if
    end subroutine collision_f

    subroutine collision_g()
        if      (col_cmd == 1) then
            call collision_BGK_g
        else if (col_cmd == 2) then
            call collision_TRT_g
        else if (col_cmd == 3) then
            call collision_TRT_g    !I don't know the physical equivalent paremeters for g in MRT
        end if
    end subroutine collision_g

    subroutine collision_h()
        if      (col_cmd == 1) then
            call collision_BGK_h
        else if (col_cmd == 2) then
            call collision_TRT_h
        else if (col_cmd == 3) then
            call collision_TRT_h    !I don't know the physical equivalent paremeters for g in MRT
        end if
    end subroutine collision_h
    !================================== Collision - End ==================================================
    
    

    !================================== Collision Operators - Beginning ============================================


    !BGK ==============================================
    subroutine collision_BGK_f()
        f_t = f*(1-dt*inv_tau_f) + feq*dt*inv_tau_f
    end subroutine collision_BGK_f

    subroutine collision_BGK_g()
        integer :: i
        do i = 1,9
            g_t(:,:,i) = g(:,:,i)*(1-dt*inv_tau_g_matrix) + geq(:,:,i)*dt*inv_tau_g_matrix
        end do
        !g_t = g*(1-dt*inv_tau_g) + geq*dt*inv_tau_g
    end subroutine collision_BGK_g

    subroutine collision_BGK_h()
        integer :: i
        do i = 1,9
            h_t(:,:,i) = h(:,:,i)*(1-dt*inv_tau_h_matrix) + heq(:,:,i)*dt*inv_tau_h_matrix
        end do
        !h_t = h*(1-dt*inv_tau_h) + heq*dt*inv_tau_h
    end subroutine collision_BGK_h

    !======================================== BGK - End

    
    !TRT ==============================================
    subroutine collision_TRT_f()
        real*8 :: f_1_p(nx,ny),f_1_m(nx,ny),f_2_p(nx,ny),f_2_m(nx,ny)
        real*8 :: f_3_p(nx,ny),f_3_m(nx,ny),f_4_p(nx,ny),f_4_m(nx,ny)
        real*8 :: f_5_p(nx,ny),f_5_m(nx,ny),f_6_p(nx,ny),f_6_m(nx,ny)
        real*8 :: f_7_p(nx,ny),f_7_m(nx,ny),f_8_p(nx,ny),f_8_m(nx,ny)
        real*8 :: feq_1_p(nx,ny),feq_1_m(nx,ny),feq_2_p(nx,ny),feq_2_m(nx,ny)
        real*8 :: feq_3_p(nx,ny),feq_3_m(nx,ny),feq_4_p(nx,ny),feq_4_m(nx,ny)
        real*8 :: feq_5_p(nx,ny),feq_5_m(nx,ny),feq_6_p(nx,ny),feq_6_m(nx,ny)
        real*8 :: feq_7_p(nx,ny),feq_7_m(nx,ny),feq_8_p(nx,ny),feq_8_m(nx,ny)
        
        !do 0th direction first
        f_t(:,:,9) = f(:,:,9) - omg_p_f*dt*(f(:,:,9)-feq(:,:,9))
        
        f_1_p = 0.5*(f(:,:,1)+f(:,:,3))
        f_1_m = 0.5*(f(:,:,1)-f(:,:,3))
        feq_1_p = 0.5*(feq(:,:,1)+feq(:,:,3))
        feq_1_m = 0.5*(feq(:,:,1)-feq(:,:,3))
        f_t(:,:,1) = f(:,:,1) - omg_p_f*dt*(f_1_p-feq_1_p) - omg_m_f*dt*(f_1_m-feq_1_m)
        
        f_2_p = 0.5*(f(:,:,2)+f(:,:,4))
        f_2_m = 0.5*(f(:,:,2)-f(:,:,4))
        feq_2_p = 0.5*(feq(:,:,2)+feq(:,:,4))
        feq_2_m = 0.5*(feq(:,:,2)-feq(:,:,4))
        f_t(:,:,2) = f(:,:,2) - omg_p_f*dt*(f_2_p-feq_2_p) - omg_m_f*dt*(f_2_m-feq_2_m)
        
        f_t(:,:,3) = f(:,:,3) - omg_p_f*dt*(f_1_p-feq_1_p) + omg_m_f*dt*(f_1_m-feq_1_m)
        
        f_t(:,:,4) = f(:,:,4) - omg_p_f*dt*(f_2_p-feq_2_p) + omg_m_f*dt*(f_2_m-feq_2_m)

        f_5_p = 0.5*(f(:,:,5)+f(:,:,7))
        f_5_m = 0.5*(f(:,:,5)-f(:,:,7))
        feq_5_p = 0.5*(feq(:,:,5)+feq(:,:,7))
        feq_5_m = 0.5*(feq(:,:,5)-feq(:,:,7))
        f_t(:,:,5) = f(:,:,5) - omg_p_f*dt*(f_5_p-feq_5_p) - omg_m_f*dt*(f_5_m-feq_5_m)

        f_6_p = 0.5*(f(:,:,6)+f(:,:,8))
        f_6_m = 0.5*(f(:,:,6)-f(:,:,8))
        feq_6_p = 0.5*(feq(:,:,6)+feq(:,:,8))
        feq_6_m = 0.5*(feq(:,:,6)-feq(:,:,8))
        f_t(:,:,6) = f(:,:,6) - omg_p_f*dt*(f_6_p-feq_6_p) - omg_m_f*dt*(f_6_m-feq_6_m)

        f_t(:,:,7) = f(:,:,7) - omg_p_f*dt*(f_5_p-feq_5_p) + omg_m_f*dt*(f_5_m-feq_5_m)

        f_t(:,:,8) = f(:,:,8) - omg_p_f*dt*(f_6_p-feq_6_p) + omg_m_f*dt*(f_6_m-feq_6_m)
    end subroutine collision_TRT_f

    subroutine collision_TRT_g()
        real*8 :: g_1_p(nx,ny),g_1_m(nx,ny),g_2_p(nx,ny),g_2_m(nx,ny)
        real*8 :: g_3_p(nx,ny),g_3_m(nx,ny),g_4_p(nx,ny),g_4_m(nx,ny)
        real*8 :: g_5_p(nx,ny),g_5_m(nx,ny),g_6_p(nx,ny),g_6_m(nx,ny)
        real*8 :: g_7_p(nx,ny),g_7_m(nx,ny),g_8_p(nx,ny),g_8_m(nx,ny)
        real*8 :: geq_1_p(nx,ny),geq_1_m(nx,ny),geq_2_p(nx,ny),geq_2_m(nx,ny)
        real*8 :: geq_3_p(nx,ny),geq_3_m(nx,ny),geq_4_p(nx,ny),geq_4_m(nx,ny)
        real*8 :: geq_5_p(nx,ny),geq_5_m(nx,ny),geq_6_p(nx,ny),geq_6_m(nx,ny)
        real*8 :: geq_7_p(nx,ny),geq_7_m(nx,ny),geq_8_p(nx,ny),geq_8_m(nx,ny)
        
        !do 0th direction first
        g_t(:,:,9) = g(:,:,9) - omg_p_g*dt*(g(:,:,9)-geq(:,:,9))
        
        g_1_p = 0.5*(g(:,:,1)+g(:,:,3))
        g_1_m = 0.5*(g(:,:,1)-g(:,:,3))
        geq_1_p = 0.5*(geq(:,:,1)+geq(:,:,3))
        geq_1_m = 0.5*(geq(:,:,1)-geq(:,:,3))
        g_t(:,:,1) = g(:,:,1) - omg_p_g*dt*(g_1_p-geq_1_p) - omg_m_g*dt*(g_1_m-geq_1_m)
        
        g_2_p = 0.5*(g(:,:,2)+g(:,:,4))
        g_2_m = 0.5*(g(:,:,2)-g(:,:,4))
        geq_2_p = 0.5*(geq(:,:,2)+geq(:,:,4))
        geq_2_m = 0.5*(geq(:,:,2)-geq(:,:,4))
        g_t(:,:,2) = g(:,:,2) - omg_p_g*dt*(g_2_p-geq_2_p) - omg_m_g*dt*(g_2_m-geq_2_m)
        
        g_t(:,:,3) = g(:,:,3) - omg_p_g*dt*(g_1_p-geq_1_p) + omg_m_g*dt*(g_1_m-geq_1_m)
        
        g_t(:,:,4) = g(:,:,4) - omg_p_g*dt*(g_2_p-geq_2_p) + omg_m_g*dt*(g_2_m-geq_2_m)

        g_5_p = 0.5*(g(:,:,5)+g(:,:,7))
        g_5_m = 0.5*(g(:,:,5)-g(:,:,7))
        geq_5_p = 0.5*(geq(:,:,5)+geq(:,:,7))
        geq_5_m = 0.5*(geq(:,:,5)-geq(:,:,7))
        g_t(:,:,5) = g(:,:,5) - omg_p_g*dt*(g_5_p-geq_5_p) - omg_m_g*dt*(g_5_m-geq_5_m)

        g_6_p = 0.5*(g(:,:,6)+g(:,:,8))
        g_6_m = 0.5*(g(:,:,6)-g(:,:,8))
        geq_6_p = 0.5*(geq(:,:,6)+geq(:,:,8))
        geq_6_m = 0.5*(geq(:,:,6)-geq(:,:,8))
        g_t(:,:,6) = g(:,:,6) - omg_p_g*dt*(g_6_p-geq_6_p) - omg_m_g*dt*(g_6_m-geq_6_m)

        g_t(:,:,7) = g(:,:,7) - omg_p_g*dt*(g_5_p-geq_5_p) + omg_m_g*dt*(g_5_m-geq_5_m)

        g_t(:,:,8) = g(:,:,8) - omg_p_g*dt*(g_6_p-geq_6_p) + omg_m_g*dt*(g_6_m-geq_6_m)
    end subroutine collision_TRT_g

    subroutine collision_TRT_h()
        real*8 :: h_1_p(nx,ny),h_1_m(nx,ny),h_2_p(nx,ny),h_2_m(nx,ny)
        real*8 :: h_3_p(nx,ny),h_3_m(nx,ny),h_4_p(nx,ny),h_4_m(nx,ny)
        real*8 :: h_5_p(nx,ny),h_5_m(nx,ny),h_6_p(nx,ny),h_6_m(nx,ny)
        real*8 :: h_7_p(nx,ny),h_7_m(nx,ny),h_8_p(nx,ny),h_8_m(nx,ny)
        real*8 :: heq_1_p(nx,ny),heq_1_m(nx,ny),heq_2_p(nx,ny),heq_2_m(nx,ny)
        real*8 :: heq_3_p(nx,ny),heq_3_m(nx,ny),heq_4_p(nx,ny),heq_4_m(nx,ny)
        real*8 :: heq_5_p(nx,ny),heq_5_m(nx,ny),heq_6_p(nx,ny),heq_6_m(nx,ny)
        real*8 :: heq_7_p(nx,ny),heq_7_m(nx,ny),heq_8_p(nx,ny),heq_8_m(nx,ny)
        
        !do 0th direction first
        h_t(:,:,9) = h(:,:,9) - omg_p_h*dt*(h(:,:,9)-heq(:,:,9))
        
        h_1_p = 0.5*(h(:,:,1)+h(:,:,3))
        h_1_m = 0.5*(h(:,:,1)-h(:,:,3))
        heq_1_p = 0.5*(heq(:,:,1)+heq(:,:,3))
        heq_1_m = 0.5*(heq(:,:,1)-heq(:,:,3))
        h_t(:,:,1) = h(:,:,1) - omg_p_h*dt*(h_1_p-heq_1_p) - omg_m_h*dt*(h_1_m-heq_1_m)
        
        h_2_p = 0.5*(h(:,:,2)+h(:,:,4))
        h_2_m = 0.5*(h(:,:,2)-h(:,:,4))
        heq_2_p = 0.5*(heq(:,:,2)+heq(:,:,4))
        heq_2_m = 0.5*(heq(:,:,2)-heq(:,:,4))
        h_t(:,:,2) = h(:,:,2) - omg_p_h*dt*(h_2_p-heq_2_p) - omg_m_h*dt*(h_2_m-heq_2_m)
        
        h_t(:,:,3) = h(:,:,3) - omg_p_h*dt*(h_1_p-heq_1_p) + omg_m_h*dt*(h_1_m-heq_1_m)
        
        h_t(:,:,4) = h(:,:,4) - omg_p_h*dt*(h_2_p-heq_2_p) + omg_m_h*dt*(h_2_m-heq_2_m)

        h_5_p = 0.5*(h(:,:,5)+h(:,:,7))
        h_5_m = 0.5*(h(:,:,5)-h(:,:,7))
        heq_5_p = 0.5*(heq(:,:,5)+heq(:,:,7))
        heq_5_m = 0.5*(heq(:,:,5)-heq(:,:,7))
        h_t(:,:,5) = h(:,:,5) - omg_p_h*dt*(h_5_p-heq_5_p) - omg_m_h*dt*(h_5_m-heq_5_m)

        h_6_p = 0.5*(h(:,:,6)+h(:,:,8))
        h_6_m = 0.5*(h(:,:,6)-h(:,:,8))
        heq_6_p = 0.5*(heq(:,:,6)+heq(:,:,8))
        heq_6_m = 0.5*(heq(:,:,6)-heq(:,:,8))
        h_t(:,:,6) = h(:,:,6) - omg_p_h*dt*(h_6_p-heq_6_p) - omg_m_h*dt*(h_6_m-heq_6_m)

        h_t(:,:,7) = h(:,:,7) - omg_p_h*dt*(h_5_p-heq_5_p) + omg_m_h*dt*(h_5_m-heq_5_m)

        h_t(:,:,8) = h(:,:,8) - omg_p_h*dt*(h_6_p-heq_6_p) + omg_m_h*dt*(h_6_m-heq_6_m)
    end subroutine collision_TRT_h
    !======================================== TRT - End
    
    
    !MRT ==============================================
    subroutine collision_MRT_f
        implicit none
        integer*8 :: x,y
        real*8    :: f_neq(nx,ny,Q)
        do x = 1, nx
            do y = 1, ny
                f_neq(x,y,:) = f(x,y,:) - feq(x,y,:)
                f_t(x,y,:) = f(x,y,:) - matmul(M_inv_S_M,f_neq(x,y,:))*dt
            end do
        end do
    end subroutine collision_MRT_f
    !======================================== MRT - End
    
    !================================== Collision Operators - End ==================================================

end module collision_mod