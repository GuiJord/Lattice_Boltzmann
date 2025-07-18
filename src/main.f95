program main
    use geometry_mod
    use parameters
    use auxiliary_mod
    use initialization_mod
    !use force_mod
    use collision_mod
    use adsorption_mod
    use thermalisation_mod
    use propagation_mod
    use boundary_conditions_mod
    use data_mod

    implicit none
    integer :: i,x,y
    integer :: msg_interval,n_msg
    integer :: profile_measurements, profile_measurements_interval
    integer :: adsorption_measurements, adsorption_measurements_interval
    real    :: progress
    character(len=20) :: profile_format



    call create_files
    call geometry
    call allocation

    !g relaxation
    allocate(inv_tau_g_matrix(nx,ny))
    do i = 1,n_fluid_points
        x = fluid_mask_x(i)
        y = fluid_mask_y(i)
        inv_tau_g_matrix(x,y) = inv_tau_g
    end do    

    do i = 1,n_ads_points_frontier
        x = mask_ads_frontier_x(i)
        y = mask_ads_frontier_y(i)
        inv_tau_g_matrix(x,y) = inv_tau_g
    end do

    do i = 1,n_ads_points
        x = mask_ads_x(i)
        y = mask_ads_y(i)
        inv_tau_g_matrix(x,y) = inv_tau_g_ads
    end do

    !h relaxation
    allocate(inv_tau_h_matrix(nx,ny))
    do i = 1,n_fluid_points
        x = fluid_mask_x(i)
        y = fluid_mask_y(i)
        inv_tau_h_matrix(x,y) = inv_tau_h
    end do
    do i = 1,n_ads_points_frontier
        x = mask_ads_frontier_x(i)
        y = mask_ads_frontier_y(i)
        inv_tau_h_matrix(x,y) = inv_tau_h
    end do

    do i = 1,n_ads_points
        x = mask_ads_x(i)
        y = mask_ads_y(i)
        inv_tau_h_matrix(x,y) = inv_tau_h_ads
    end do


    !================================== Initialization - Beginning ============================================
    call initialization_f
    call initialization_g
    call initialization_h
    !================================== Initialization - End ==================================================
    

    
    !Plot data ==============================================
    open(10,file='conservation.dat',status='replace')
    close(10)

    open(10,file='adsorption.dat',status='replace')
    close(10)

    write(profile_format,'(A,I0,A)') '(I0,A,',ny,'F10.4)'

    open(10,file='concentration.dat',status='replace')
    close(10)

    open(10,file='temperature.dat',status='replace')
    close(10)

    ! open(10,file='conductivity.dat',status='replace')
    ! close(10)
    !======================================== Plot data - End
    
    
    
    !================================== Main Loop - Beginning ============================================

    time_step = 0
    do while (time_step <= tmax)


        adsorption_measurements = 100
        adsorption_measurements_interval = int(tmax/adsorption_measurements)

        if ( mod(time_step,adsorption_measurements_interval) == 0 ) then
            call adsorption_measurements_data
        end if

        profile_measurements = 100
        profile_measurements_interval = int(tmax/profile_measurements)

        if ( mod(time_step,profile_measurements_interval) == 0 ) then
            open(10,file='concentration.dat', status="old", position="append")
            write(10,profile_format) time_step,' ',C(nx/2,:)
            close(10)   

            open(10,file='temperature.dat', status="old", position="append")
            write(10,profile_format) time_step, ' ', T(nx/2,:)
            close(10)

            ! open(10,file='conductivity.dat', status="old", position="append")
            ! write(10,profile_format) time_step, ' ', 1/inv_tau_h_matrix(nx/2,:)
            ! close(10)
        end if
        
       
       !Equilibrium Functions Calculation ==============================================
        call equilibrium_func_f
        call equilibrium_func_g
        call equilibrium_func_h
       !======================================== Equilibrium Functions Calculation - End

        
        !Collision ==============================================
        call collision_f
        call collision_g
        call collision_h
        !======================================== Collision - End

        ! call make_concentration_constant

        !Adsorption ==============================================

        ! call adsorption_old
        call adsorption_new_new
        ! call adsorption_new
        ! call adsorption
        call rattle_effect

        !======================================== Adsorption - End
        

        !Thermalization ==============================================
        ! call thermalisation
        !======================================== Thermalization - End
        
        
        !Propagation ==============================================
        call propagation_f
        call propagation_g
        call propagation_h
        !======================================== Propagation - End
        
        
        !Moments Calculation ==============================================
        call moments_f
        call moments_g
        call moments_h
        !======================================== Moments Calculation - End
        
        ! call make_concentration_constant

        
        !Error Calculation ==============================================
        call error_f
        call error_g
        call error_h
        !======================================== Error Calculation - End
        

        
        !Updating Variables ==============================================
        call update_f
        call update_g
        call update_h
        !======================================== Updating Variables - End
        
        

        call data_collection
        
        
    !     !von Kàrmàn Tests ==============================================
    !     ! call tortuosity_calc
    !     ! call error_tortuosity_calc
    !     ! tortuosity_old = tortuosity
    !     ! !von Kármán study
    !     ! call update_f
    !     ! !call data_collection
    !     ! if ( time_step < 30000 ) then
            
    !     ! end if
    !     ! if ( time_step >= 30000 ) then
    !     !     call equilibrium_func_g
    !     !     call collision_g
    !     !     call propagation_g
    !     !     C(1,ny/2+10) = 5.d0
    !     !     C(1,ny/2-10) = 5.d0  
    !     !     call moments_g
    !     !     call data_collection
    !     ! end if
    !     !======================================== von Kàrmàn Tests - End
        


        !Statistics
        progress = 100.0 * time_step/tmax
        !progress = 100.0*tol/error_u
        
        !msg_interval = 10
        !n_msg = 10!int(tmax/msg_interval)
        !msg_interval = int(tmax/n_msg)
        msg_interval = 10!int(0.001*tmax)

        if (mod(time_step,msg_interval) == 0) then
            write(*,'(A,F6.1,A,A,I8,A,1PE8.1,A,1PE8.1,A,1PE8.1)')&
            &'  Progress:', progress,'%', '   ||   Time Step:', time_step,'   ||   Error (u):', error_u,&
            &'   ||   Error (C):', error_C, '   ||   Error (T):', error_T
        end if
        
        time_step = time_step + 1
    end do
    !================================== Main Loop - End ==================================================
    
    ! open(10,file='temperature.dat', status="old", position="append")
    ! write(10,'(100F10.4)')T(nx/2,:)
    ! close(10)
    
end program main