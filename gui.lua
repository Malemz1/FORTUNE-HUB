            -- Activate No Cooldown Skill modifications

            -- Override Steal function
            local TweenService = game:GetService("TweenService")
            local originalSteal = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Bachira.Steal)
            
            local newSteal = function(v11, v12, v13)
                -- ข้ามเงื่อนไขคูลดาวน์และพลังงาน
                if false then -- ข้ามการตรวจสอบทุกอย่าง
                    return
                end
            
                if v11.ABC then
                    v11.ABC:Clean()
                end
                if v11.SlideTrove then
                    v11.SlideTrove:Destroy()
                end
            
                -- ส่วนสำหรับเมื่อผู้เล่นมีบอล
                if v13.Values.HasBall.Value then
                    v11.AbilityController:AbilityCooldown("1", 1) -- ไม่มีคูลดาวน์
                    v11.StaminaService.DecreaseStamina:Fire(10) -- ไม่ลด Stamina
                    v11.StatesController.States.Ability = true
                    v11.StatesController.OwnWalkState = true
                    v11.StatesController.SpeedBoost = 5
            
                    task.delay(2, function()
                        v11.StatesController.States.Ability = false
                        v11.StatesController.OwnWalkState = false
                        v11.StatesController.SpeedBoost = 0
                    end)
            
                    v11.Animations:StopAnims()
                    v11.Animations.Abilities.HeelPass.Priority = Enum.AnimationPriority.Action3
                    v11.Animations.Abilities.HeelPass:Play()
                    v11.Animations.Ball.HeelPass.Priority = Enum.AnimationPriority.Action3
                    v11.Animations.Ball.HeelPass:Play()
                    v11.AbilityService.Ability:Fire("HeelPass")
                    v11.ABC:Connect(v11.AbilityService.Ability, function(v14)
                        v11.ABC:Clean()
                        v11.StatesController.States.Ability = false
                        v11.StatesController.OwnWalkState = false
                        v11.StatesController.SpeedBoost = 0
                        v14.AssemblyLinearVelocity = (v13.HumanoidRootPart.CFrame.LookVector + Vector3.new(0, 0.55, 0)) * 80
                        v11.BallController:DragBall(v14)
                    end)
                else
                    -- ส่วนสำหรับเมื่อผู้เล่นไม่มีบอล
                    v11.AbilityController:AbilityCooldown("1", 1) -- ไม่มีคูลดาวน์
                    v11.StaminaService.DecreaseStamina:Fire(10) -- ไม่ลด Stamina
                    v11.Animations:StopAnims()
                    v11.Animations.Abilities.Steal.Priority = Enum.AnimationPriority.Action
                    v11.Animations.Abilities.Steal:Play()
            
                    -- เรียกใช้ RemoteEvent "Slide" เพื่อ FireServer
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Slide:FireServer()
                    print("Slide RemoteEvent has been fired!")
            
                    -- ใช้ TweenService แทนการพุ่งด้วย BodyVelocity
                    local rootPart = v13.HumanoidRootPart
                    if rootPart then
                        local targetPosition = rootPart.Position + (rootPart.CFrame.LookVector * 30) -- พุ่งไปข้างหน้า 10 หน่วย
            
                        local tweenInfo = TweenInfo.new(
                            0.4, -- ระยะเวลาพุ่ง (0.5 วินาที)
                            Enum.EasingStyle.Linear, -- รูปแบบการเคลื่อนไหวแบบ Linear
                            Enum.EasingDirection.Out, -- ทิศทางการเคลื่อนไหวแบบ Out
                            0, -- จำนวนรอบ (0 = ไม่ทำซ้ำ)
                            false, -- ไม่ย้อนกลับ
                            0 -- ไม่มีดีเลย์ก่อนเริ่ม Tween
                        )
            
                        local tweenGoal = {Position = targetPosition}
                        local tween = TweenService:Create(rootPart, tweenInfo, tweenGoal)
            
                        tween:Play()
                        print("Tween started. Moving to:", targetPosition)
            
                        tween.Completed:Connect(function()
                            print("Tween completed. Reached:", targetPosition)
                            tween:Destroy() -- ลบ Tween หลังการใช้งาน
                        end)
                    end
                end
            end
            
            -- แทนที่ฟังก์ชันใน ModuleScript
            hookfunction(originalSteal, newSteal)

            -- Override AirDribble function
            local airdribbleModule = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Nagi.AirDribble)
            
            -- Define the new function
            local function newAirDribble(v13, v14, v15)
                if v13.__trapped then
                    if not v15.Values.HasBall.Value then
                        return
                    else
                        v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Trap"
                        v13.Animations:StopAnims()
                        v13.Animations.Abilities.AirDribbleShoot.Priority = Enum.AnimationPriority.Action4
                        v13.Animations.Abilities.AirDribbleShoot:Play()
                        v13.Animations.Ball.AirDribbleShoot.Priority = Enum.AnimationPriority.Action4
                        v13.Animations.Ball.AirDribbleShoot:Play()
                        if v13.ABC then
                            v13.ABC:Clean()
                        end
                        v13.ABC:Add(function()
                            v13.__trapped = nil
                        end)
                        task.delay(0.35, function()
                            v13.AbilityService.Ability:Fire("AirDribble", "shotStart")
                        end)
                        v13.ABC:Add(v13.AbilityService.Ability:Connect(function(v16)
                            v16.AssemblyLinearVelocity = (workspace.CurrentCamera.CFrame.LookVector + Vector3.new(0, 0.35, 0)) * 125
                            v13.BallController:DragBall(v16)
                        end))
                        return
                    end
                else
                    if v13.ABC then
                        v13.ABC:Clean()
                    end
                    v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Shoot"
                    task.delay(0.45, function()
                        v13.InAbility = true
                    end)
                    local l_Value_0 = v15.Values.HasBall.Value
                    v15.HumanoidRootPart.Anchored = true
                    v13.AbilityService.Ability:Fire("AirDribble")
                    v13.Animations:StopAnims()
                    if l_Value_0 then
                        v13.Animations.Abilities.AirDribbleUp.Priority = Enum.AnimationPriority.Action2
                        v13.Animations.Abilities.AirDribbleUp:Play()
                        v13.Animations.Ball.AirDribbleUp.Priority = Enum.AnimationPriority.Action2
                        v13.Animations.Ball.AirDribbleUp:Play()
                        v13.Animations.Abilities.AirDribbleUp:AdjustSpeed(1.35)
                        v13.Animations.Ball.AirDribbleUp:AdjustSpeed(1.35)
                    end
                    v13.Animations.Ball.AirDribbleStart.Priority = Enum.AnimationPriority.Action3
                    v13.Animations.Ball.AirDribbleStart:Play()
                    v13.Animations.Ball.AirDribbleStart:AdjustSpeed(1.35)
                    v13.Animations.Abilities.AirDribbleStart.Priority = Enum.AnimationPriority.Action3
                    v13.Animations.Abilities.AirDribbleStart:Play()
                    v13.__trapped = true
                    v13.ABC:Add(function()
                        v13.__trapped = nil
                    end)
                    local v18 = os.time() + 4
                    task.delay(0.65, function()
                        v13.ABC:Connect(game:GetService("RunService").Heartbeat, function()
                            if v15 == nil then
                                if v13.ABC then
                                    v13.ABC:Clean()
                                end
                                v13.InAbility = false
                                return
                            else
                                if v15.Values.HasBall.Value then
                                    l_Value_0 = true
                                end
                                if (v18 < os.time() or not v13.InAbility or not v15.Values.HasBall.Value and l_Value_0) and v13.ABC then
                                    v13.ABC:Clean()
                                end
                                return
                            end
                        end)
                    end)
                    v13.ABC:Add(function()
                        v14.PlayerGui.InGameUI.Bottom.Abilities["1"].Timer.Text = "Trap"
                        task.delay(0.15, function()
                            v15.HumanoidRootPart.Anchored = false
                        end)
                        v13.InAbility = false
                        v13.Animations.Abilities.AirDribbleStart:Stop()
                        v13.Animations.Ball.AirDribbleStart:Stop()
                    end)
                    return
                end
            end
            
            -- Hook the function using hookfunction
            hookfunction(airdribbleModule, newAirDribble)
            

            -- Override AirDash function
            local originalAirDash = require(game:GetService("ReplicatedStorage").Controllers.AbilityController.Abilities.Nagi.AirDash)

            local function newAirDash(v13, v14, v15)
                if v13.ABC then
                    v13.ABC:Clean()
                end
            
                -- Un-anchor the player's HumanoidRootPart
                v15.HumanoidRootPart.Anchored = false
            
                -- Stop animations
                v13.Animations:StopAnims()
            
                -- Determine dash direction
                local dashDirection = "Right"
                if v15.HumanoidRootPart.CFrame:VectorToObjectSpace(v15.Humanoid.MoveDirection).X < 0 then
                    dashDirection = "Left"
                end
                local directionVector = dashDirection == "Right" and v15.HumanoidRootPart.CFrame.RightVector or -v15.HumanoidRootPart.CFrame.RightVector
            
                -- Adjust position instantly
                local dashDistance = 15 -- Dash distance
                v15.HumanoidRootPart.CFrame = v15.HumanoidRootPart.CFrame + (directionVector * dashDistance)
            
                -- Trigger ability and animations
                v13.AbilityService.Ability:Fire("AirDash", directionVector)
                v13.Animations.Abilities["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
                v13.Animations.Abilities["AirDribble" .. dashDirection]:Play()
                v13.Animations.Ball["AirDribble" .. dashDirection].Priority = Enum.AnimationPriority.Action4
                v13.Animations.Ball["AirDribble" .. dashDirection]:Play()
            end
            
            -- Hook the original AirDash function
            hookfunction(originalAirDash, newAirDash)

            Fluent:Notify({
                Title = "No Cooldown Skill Enabled",
                Content = "All skills now have no cooldown.",
                Duration = 3
            })
        else
            -- Deactivate modifications (optional: reload original scripts)
            Fluent:Notify({
                Title = "No Cooldown Skill Disabled",
                Content = "Skills are back to normal.",
                Duration = 3
            })
        end
    end
})
