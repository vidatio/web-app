# User Service Test
# =================

# "use strict"

# describe "testing component 'UserService'", ->

#     UserService = undefined

#     beforeEach ->
#         module "app"
#         inject ( _UserService_ ) ->
#             UserService = _UserService_


#     it "should be available", ->
#         expect( UserService ).toBeDefined()

#     it "should have an 'name'", ->
#         expect( UserService.user.name ).toBeDefined()

#     it "should have a User resource object", ->
#         expect( UserService.user ).toBeDefined()
#         expect( UserService.user ).toEqual(jasmine.any(Object))

#     describe "init function", ->

#         it "should be defined", ->
#             expect( UserService.init ).toBeDefined()
#             expect( UserService.init ).toEqual(jasmine.any(Function))

#         it "should init the User resource", ->
#             UserService.init 1
#             expect( UserService.user.name ).toBeDefined()

