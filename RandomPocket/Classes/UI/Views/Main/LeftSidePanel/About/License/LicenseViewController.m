//
//  LicenseViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/12.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LicenseViewController.h"
#import "LicenseCell.h"

static NSString* const LicenseCellIdentifier = @"LicenseCell";
const NSString* TitleKey = @"title";
const NSString* CopyrightKey = @"copyright";
const NSString* DescriptionKey = @"description";
const NSString* TypeKey = @"type";

@interface LicenseViewController ()
@property (nonatomic) NSArray *licenses;
@end

@implementation LicenseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"LicenseCell" bundle:nil] forCellReuseIdentifier:LicenseCellIdentifier];
    self.licenses = self.licenseData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.licenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:LicenseCellIdentifier forIndexPath:indexPath];
    cell.LicenseData = self.licenses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:LicenseCellIdentifier];
    cell.LicenseData = self.licenses[indexPath.row];
    
    if([cell.LicenseData[TypeKey] isEqualToString:@"Image"]){
        return 125.f;
    }
    
    return cell.cellHeight;
}

#pragma mark -

- (NSArray*)licenseData
{
    return @[
             @{TitleKey: @"Pocket-ObjC-SDK",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2012 Read It Later, Inc.",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"BlocksKit",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2011-2012 Zachary Waldowski, Alexsander Akers, and the BlocksKit Contributors",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"Toast for iOS",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Charles Scalesse.",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining acopy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, includingwithout limitation the rights to use, copy, modify, merge, publish,\ndistribute, sublicense, and/or sell copies of the Software, and topermit persons to whom the Software is furnished to do so, subject to\nthe following conditions:\n    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"MRProgress",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Marius Rackwitz git@mariusrackwitz.de",
               DescriptionKey: @"The MIT License\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"Appirater",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright 2013. Arash Payan. This library is distributed under the terms of the MIT/X11.",
               DescriptionKey: @"While not required, I greatly encourage and appreciate any improvements that you make to this library be contributed back for the benefit of all who use Appirater."},

             @{TitleKey: @"PBWebViewController",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Mikael Konutgan",
               DescriptionKey: @"MIT License\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"MSCMoreOptionTableViewCell",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Manfred Scheiner",
               DescriptionKey: @"The MIT License (MIT)\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},

             @{TitleKey: @"SDWebImage",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2009 Olivier Poitrey <rs@dailymotion.com>",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},
             @{TitleKey: @"NJKScrollFullScreen",
               TypeKey:@"Library",
               CopyrightKey: @"Copyright (c) 2013 Satoshi Asano",
               DescriptionKey: @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."},
             /*
             @{TitleKey: @"Crittercism iOS Library",
               CopyrightKey: @"Copyright 2010-2013 Crittercism, Inc. All rights reserved",
               DescriptionKey: @""},
              */
             @{TitleKey: @"Earth Icon",
               TypeKey:@"Image",
               CopyrightKey: @"By PixelKit",
               DescriptionKey: @"Creative Commons (Attribution 3.0 Unported) https://www.iconfinder.com/icons/239244/earth_global_globe_network_planet_web_world_icon"},
             @{TitleKey: @"Home Icon",
               TypeKey:@"Image",
               CopyrightKey: @"By Visual Pharm - http://icons8.com/",
               DescriptionKey: @"Creative Commons Attribution-No Derivative Works 3.0 Unported (read me) https://www.iconfinder.com/icons/172480/home_icon"},
             @{TitleKey: @"Info Icon",
               TypeKey:@"Image",
               CopyrightKey: @"By Visual Pharm - http://icons8.com/",
               DescriptionKey: @"Creative Commons Attribution-No Derivative Works 3.0 Unported (read me) https://www.iconfinder.com/icons/172480/home_icon"},
             ];
}

@end
